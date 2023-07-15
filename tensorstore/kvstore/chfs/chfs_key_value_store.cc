#include <errno.h>

#include <cstddef>
#include <cstring>
#include <fstream>
#include <string>
#include <tuple>
#include <type_traits>
#include <utility>
#include <vector>

#include <chfs.h>
#include "absl/functional/function_ref.h"
#include "absl/status/status.h"
#include "absl/strings/cord.h"
#include "absl/strings/match.h"
#include "absl/time/clock.h"
#include <nlohmann/json.hpp>
#include "tensorstore/context.h"
#include "tensorstore/internal/cache_key/cache_key.h"
#include "tensorstore/internal/context_binding.h"
#include "tensorstore/internal/file_io_concurrency_resource.h"
#include "tensorstore/internal/flat_cord_builder.h"
#include "tensorstore/internal/json_binding/bindable.h"
#include "tensorstore/internal/json_binding/json_binding.h"
#include "tensorstore/internal/metrics/counter.h"
#include "tensorstore/internal/os_error_code.h"
#include "tensorstore/internal/uri_utils.h"
#include "tensorstore/kvstore/byte_range.h"
#include "tensorstore/kvstore/generation.h"
#include "tensorstore/kvstore/key_range.h"
#include "tensorstore/kvstore/registry.h"
#include "tensorstore/kvstore/url_registry.h"
#include "tensorstore/util/execution/any_receiver.h"
#include "tensorstore/util/execution/execution.h"
#include "tensorstore/util/execution/sender.h"
#include "tensorstore/util/executor.h"
#include "tensorstore/util/future.h"
#include "tensorstore/util/quote_string.h"
#include "tensorstore/util/result.h"
#include "tensorstore/util/status.h"
#include "tensorstore/util/str_cat.h"

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>

namespace tensorstore {
namespace {

namespace jb = tensorstore::internal_json_binding;

using ::tensorstore::internal::GetLastErrorCode;
using ::tensorstore::internal::GetOsErrorStatusCode;
using ::tensorstore::internal::OsErrorCode;
using ::tensorstore::internal::StatusFromOsError;
using ::tensorstore::kvstore::ReadResult;
using ::tensorstore::kvstore::SupportedFeatures;

typedef struct ::stat FileInfo;

auto& chfs_bytes_read = internal_metrics::Counter<int64_t>::New(
    "/tensorstore/kvstore/chfs/bytes_read",
    "Bytes read by the chfs kvstore driver");

auto& chfs_bytes_written = internal_metrics::Counter<int64_t>::New(
    "/tensorstore/kvstore/chfs/bytes_written",
    "Bytes written by the chfs kvstore driver");

auto& chfs_read_op = internal_metrics::Counter<int64_t>::New(
    "/tensorstore/kvstore/chfs/read", "chfs driver kvstore::Read calls");

auto& chfs_write_op = internal_metrics::Counter<int64_t>::New(
    "/tensorstore/kvstore/chfs/write", "chfs driver kvstore::Write calls");

auto& chfs_delete_range = internal_metrics::Counter<int64_t>::New(
    "/tensorstore/kvstore/chfs/delete_range",
    "chfs driver kvstore::DeleteRange calls");

auto& chfs_list = internal_metrics::Counter<int64_t>::New(
    "/tensorstore/kvstore/chfs/list", "chfs driver kvstore::List calls");


struct CHFSKeyValueStoreSpecData {
  Context::Resource<internal::FileIoConcurrencyResource> file_io_concurrency;

  constexpr static auto ApplyMembers = [](auto& x, auto f) {
    return f(x.file_io_concurrency);
  };

  // TODO(jbms): Storing a UNIX path as a JSON string presents a challenge
  // because UNIX paths are byte strings, and while it is common to use
  // UTF-8 encoding it is not required that the path be a valid UTF-8
  // string.  On MS Windows, there is a related problem that path names
  // are stored as UCS-2 may contain invalid surrogate pairs.
  //
  // However, while supporting such paths is important for general purpose
  // software like a file backup tool, it is relatively unlikely that the
  // user will want to use such a path as the root of a file-backed
  // KeyValueStore.
  //
  // If we do want to support such paths, there are various options
  // including base64-encoding, or using NUL as an escape sequence (taking
  // advantage of the fact that valid paths on all operating systems
  // cannot contain NUL characters).
  constexpr static auto default_json_binder = jb::Object(jb::Member(
      internal::FileIoConcurrencyResource::id,
      jb::Projection<&CHFSKeyValueStoreSpecData::file_io_concurrency>()));
};

class CHFSKeyValueStoreSpec
    : public internal_kvstore::RegisteredDriverSpec<CHFSKeyValueStoreSpec,
                                                    CHFSKeyValueStoreSpecData> {
 public:
  static constexpr char id[] = "chfs";

  Future<kvstore::DriverPtr> DoOpen() const override;

  Result<std::string> ToUrl(std::string_view path) const override {
    return tensorstore::StrCat(id, "://", internal::PercentEncodeUriPath(path));
  }
};



class CHFSKeyValueStore
    : public internal_kvstore::RegisteredDriver<CHFSKeyValueStore,CHFSKeyValueStoreSpec> {
 public:
  Future<ReadResult> Read(Key key, ReadOptions options) override;

  Future<TimestampedStorageGeneration> Write(Key key,
                                             std::optional<Value> value,
                                             WriteOptions options) override;

  Future<const void> DeleteRange(KeyRange range) override;

  void ListImpl(ListOptions options,
                AnyFlowReceiver<absl::Status, Key> receiver) override;
    
  const Executor& executor() { return spec_.file_io_concurrency->executor; }

  std::string DescribeKey(std::string_view key) override {
    return tensorstore::StrCat("chfs file ", tensorstore::QuoteString(key));
  }

  absl::Status GetBoundSpecData(CHFSKeyValueStoreSpecData& spec) const {
    spec = spec_;
    return absl::OkStatus();
  }

  SupportedFeatures GetSupportedFeatures(
      const KeyRange& key_range) const final {
    return SupportedFeatures::kNone;
  }

  SpecData spec_;
};

struct PosixMTime {
  std::int64_t sec;
  std::int64_t nsec;
};

// Encode in the generation fields that uniquely identify the file.
StorageGeneration GetFileGeneration(const FileInfo& info) {
  return StorageGeneration::FromValues(info.st_dev,
                                       info.st_ino,
                                       PosixMTime{info.st_mtim.tv_sec, info.st_mtim.tv_nsec});
}

/// Returns a absl::Status for the current errno value. The message is composed
/// by catenation of the provided string parts.
absl::Status StatusFromErrno(std::string_view a = {}, std::string_view b = {},
                             std::string_view c = {}, std::string_view d = {}) {
  return StatusFromOsError(GetLastErrorCode(), a, b, c, d);
}

absl::Status VerifyRegularFile(int fd, FileInfo* info,
                               const char* path) {
  int ret;
  ret = chfs_stat(path, info);
  if (ret < 0) {
    return StatusFromErrno("Error getting file information: ", path);
  }
  if (!S_ISREG(info->st_mode)) {
    return absl::FailedPreconditionError(
        tensorstore::StrCat("Not a regular file: ", path));
  }
  return absl::OkStatus();
}

Result<int> OpenValueFile(const char* path,
                                           StorageGeneration* generation,
                                           std::int64_t* size = nullptr) {
  int fd = chfs_open(path, O_RDWR);
  if (fd < 0) {
    auto error = GetLastErrorCode();
    if (GetOsErrorStatusCode(error) == absl::StatusCode::kNotFound) {
      *generation = StorageGeneration::NoValue();
      return fd;
    }
    return StatusFromOsError(error, "Error opening file: ", path);
  }
  FileInfo info;
  TENSORSTORE_RETURN_IF_ERROR(VerifyRegularFile(fd, &info, path));
  if (size) *size = info.st_size;
  *generation = GetFileGeneration(info);
  return fd;
}

std::string_view LongestDirectoryPrefix(const KeyRange& range) {
  std::string_view prefix = tensorstore::LongestPrefix(range);
  const size_t i = prefix.rfind('/');
  if (i == std::string_view::npos) return {};
  return prefix.substr(0, i);
}

struct PathRangeVisitor {
  KeyRange range;
  std::string prefix;

  PathRangeVisitor(KeyRange range)
      : range(std::move(range)), prefix(LongestDirectoryPrefix(this->range)) {}

  struct ChildEntry {
    std::string name;
    bool isdir;
  };

  static int getfileinfo_filler(void *buf, const char *name, const struct stat *st, off_t off) {
    if (name[0] == '.' && (name[1] == '\0' || (name[1] == '.' && name[2] == '\0'))) {
      return 0;
    }
    std::vector<ChildEntry> *ents = (std::vector<ChildEntry> *)buf;
    if (S_ISDIR(st->st_mode)) {
      ents->push_back({std::string(name), true});
    } else if (S_ISREG(st->st_mode)) {
      ents->push_back({std::string(name), false});
    }
    return 0;
  }


  absl::Status Visit(
    absl::FunctionRef<bool()> is_cancelled,
    absl::FunctionRef<absl::Status(std::string path)> handle_file_at,
    absl::FunctionRef<absl::Status(bool fully_contained, std::string path)> handle_dir_at
  ) {
    int ret;
    FileInfo info;
    ret = chfs_stat(prefix.c_str(), &info);
    if (ret < 0 || !S_ISDIR(info.st_mode)) {
      return StatusFromErrno("Failed to open directory");
    }
    bool fully_contained = tensorstore::ContainsPrefix(range, GetFullDirPath(prefix));
    return Visit_dfs(prefix, fully_contained, is_cancelled, handle_file_at, handle_dir_at);
  }

  absl::Status Visit_dfs(
    std::string path,
    bool fully_contained,
    absl::FunctionRef<bool()> is_cancelled,
    absl::FunctionRef<absl::Status(std::string path)> handle_file_at,
    absl::FunctionRef<absl::Status(bool fully_contained, std::string path)> handle_dir_at
  ) {
    if (is_cancelled()) {
      return absl::CancelledError("");
    }
    int ret;
    std::vector<ChildEntry> ents;
    ret = chfs_readdir(path.c_str(), &ents, getfileinfo_filler);
    if (ret < 0) {
      return StatusFromErrno("Failed to chfs_readdir");
    }
    for (ChildEntry ent: ents) {
      std::string next_path = GetFullDirPath(path) + ent.name;
      if (ent.isdir) {
        if (fully_contained || tensorstore::IntersectsPrefix(range, next_path)) {
          bool next_fully_contained = fully_contained ||
            tensorstore::ContainsPrefix(range, GetFullDirPath(next_path));
          TENSORSTORE_RETURN_IF_ERROR(
            Visit_dfs(next_path, next_fully_contained,
              is_cancelled, handle_file_at, handle_dir_at));
        }
      } else {
        if (fully_contained || tensorstore::Contains(range, next_path)) {
          TENSORSTORE_RETURN_IF_ERROR(handle_file_at(next_path));
        }
      }
    }
    TENSORSTORE_RETURN_IF_ERROR(handle_dir_at(fully_contained, path));
    return absl::OkStatus();
  }

  std::string GetFullDirPath(std::string path) {
    if (!path.empty() && path.back() != '/') {
      path += '/';
    }
    return path;
  }

};

/// Implements `CHFSKeyValueStore::Read`.
struct CHFSReadTask {
  std::string full_path;
  kvstore::ReadOptions options;

  Result<ReadResult> operator()() const {
    ReadResult read_result;
    read_result.stamp.time = absl::Now();
    std::int64_t size;
    TENSORSTORE_ASSIGN_OR_RETURN(
        int fd,
        OpenValueFile(full_path.c_str(), &read_result.stamp.generation, &size));
    if (read_result.stamp.generation == options.if_not_equal ||
        (!StorageGeneration::IsUnknown(options.if_equal) &&
         read_result.stamp.generation != options.if_equal)) {
      return read_result;
    }
    TENSORSTORE_ASSIGN_OR_RETURN(auto byte_range,
                                 options.byte_range.Validate(size));
    read_result.state = ReadResult::kValue;
    internal::FlatCordBuilder buffer(byte_range.size());
    std::size_t offset = 0;
    while (offset < buffer.size()) {
      ssize_t n = chfs_pread(fd, buffer.data() + offset, buffer.size() - offset, byte_range.inclusive_min + offset);
      if (n > 0) {
        chfs_bytes_read.IncrementBy(n);
        offset += n;
        continue;
      }
      if (n == 0) {
        return absl::UnavailableError(
            tensorstore::StrCat("Length changed while reading: ", full_path));
      }
      return StatusFromErrno("Error reading file: ", full_path);
    }
    read_result.value = std::move(buffer).Build();
    return read_result;
  }
};

Future<ReadResult> CHFSKeyValueStore::Read(Key key, ReadOptions options) {
  chfs_read_op.Increment();
  return MapFuture(executor(), CHFSReadTask{std::move(key), std::move(options)});
}

/// Implements `CHFSKeyValueStore::Write`.

struct CHFSWriteTask {
  std::string full_path;
  absl::Cord value;
  kvstore::WriteOptions options;

  Result<TimestampedStorageGeneration> operator()() const {
    TimestampedStorageGeneration r;
    r.time = absl::Now();
    int ret;
    int fd;
    FileInfo info;
    ret = chfs_stat(full_path.c_str(), &info);
    if (!StorageGeneration::IsUnknown(options.if_equal)) {
      if (ret != 0 && !StorageGeneration::IsNoValue(options.if_equal)) {
        r.generation = StorageGeneration::Unknown();
        return r;
      }
      if (ret == 0 && GetFileGeneration(info) != options.if_equal) {
        r.generation = StorageGeneration::Unknown();
        return r;
      }
    }
    if (ret != 0) {
      fd = chfs_create(full_path.c_str(), O_RDWR, S_IRWXU);
      if (fd < 0) {
        auto error = GetLastErrorCode();
        return StatusFromOsError(error, "Error opening file: ", full_path);
      }
    } else {
      fd = chfs_open(full_path.c_str(), O_RDWR);
      if (fd < 0) {
        auto error = GetLastErrorCode();
        return StatusFromOsError(error, "Error opening file: ", full_path);
      }
      ret = chfs_truncate(full_path.c_str(), 0);
      if (ret < 0) {
        auto error = GetLastErrorCode();
        return StatusFromOsError(error, "Error truncate file: ", full_path);
      }
    }
    ssize_t n;
    for (absl::string_view chunk : value.Chunks()) {
      size_t offset = 0;
      while (offset < chunk.size()) {
        n = chfs_write(fd, (void *)chunk.data(), (size_t)chunk.size() - offset);
        if (n < 0 || n == 0) {
          return StatusFromErrno("Error writing to file: ", full_path);
        }
        chfs_bytes_written.IncrementBy(n);
        offset += n;
      }
    }
    ret = chfs_close(fd);
    if (ret < 0) {
      return StatusFromErrno("Error closing to file: ", full_path);
    }
    ret = chfs_stat(full_path.c_str(), &info);
    if (ret < 0) {
      return StatusFromErrno("Error stat to file: ", full_path);
    }
    r.generation = GetFileGeneration(info);
    return r;
  }
};

struct CHFSDeleteTask {
  std::string full_path;
  kvstore::WriteOptions options;

  Result<TimestampedStorageGeneration> operator()() const {
    TimestampedStorageGeneration r;
    r.time = absl::Now();
    int ret;
    FileInfo info;
    ret = chfs_stat(full_path.c_str(), &info);
    if (!StorageGeneration::IsUnknown(options.if_equal)) {
      if (ret != 0 && !StorageGeneration::IsNoValue(options.if_equal)) {
        r.generation = StorageGeneration::Unknown();
        return r;
      }
      if (ret == 0 && GetFileGeneration(info) != options.if_equal) {
        r.generation = StorageGeneration::Unknown();
        return r;
      }
    }
    if (ret == 0) {
      ret = chfs_unlink(full_path.c_str());
      if (ret < 0) {
        return StatusFromErrno("Error unlink to file: ", full_path);
      }
    }
    r.generation = StorageGeneration::NoValue();
    return r;
  }
};

Future<TimestampedStorageGeneration> CHFSKeyValueStore::Write(
    Key key, std::optional<Value> value, WriteOptions options) {
  chfs_write_op.Increment();
  if (value) {
    return MapFuture(executor(), CHFSWriteTask{std::move(key), std::move(*value),
                                           std::move(options)});
  } else {
    return MapFuture(executor(),
                     CHFSDeleteTask{std::move(key), std::move(options)});
  }
}

/// Implements `CHFSKeyValueStore::DeleteRange`.

struct CHFSDeleteRangeTask {
  KeyRange range;

  void operator()(Promise<void> promise) {
    PathRangeVisitor visitor(range);
    auto is_cancelled = [&promise] { return !promise.result_needed(); };
    auto remove_directory = [&](bool fully_contained, std::string path) {
      if (!fully_contained) {
        return absl::OkStatus();
      }
      int ret;
      ret = chfs_rmdir(path.c_str());
      if (ret < 0) {
        return StatusFromErrno("Failed to remove directory");
      }
      return absl::OkStatus();
    };
    auto delete_file = [&](std::string path) {
      int ret;
      ret = chfs_unlink(path.c_str());
      if (ret < 0) {
        return StatusFromErrno("Failed to remove file");
      }
      return absl::OkStatus();
    };
    promise.SetResult(
      MakeResult(visitor.Visit(is_cancelled, delete_file, remove_directory)));
  }
};

Future<const void> CHFSKeyValueStore::DeleteRange(KeyRange range) {
  chfs_delete_range.Increment();
  if (range.empty()) return absl::OkStatus();  // Converted to a ReadyFuture.
  return PromiseFuturePair<void>::Link(
             WithExecutor(executor(), CHFSDeleteRangeTask{std::move(range)}))
      .future;
}

/// Implements `CHFSKeyValueStore:::List`.
struct CHFSListTask {
  KeyRange range;
  size_t strip_prefix_length;
  AnyFlowReceiver<absl::Status, kvstore::Key> receiver;

  void operator()() {
    PathRangeVisitor visitor(range);
    std::atomic<bool> cancelled = false;
    execution::set_starting(receiver, [&cancelled] {
      cancelled.store(true, std::memory_order_relaxed);
    });
    auto is_cancelled = [&cancelled] {
      return cancelled.load(std::memory_order_relaxed);
    };
    auto handle_file_at = [this, &visitor](std::string path) {
      path.erase(0, strip_prefix_length);
      execution::set_value(receiver, std::move(path));
      return absl::OkStatus();
    };
    auto handle_dir_at = [](bool fully_contained, std::string path) {
      return absl::OkStatus();
    };
    auto status = visitor.Visit(is_cancelled, handle_file_at, handle_dir_at);
    if (!status.ok() && !is_cancelled()) {
      execution::set_error(receiver, std::move(status));
      execution::set_stopping(receiver);
      return;
    }
    execution::set_done(receiver);
    execution::set_stopping(receiver);
  }
};

void CHFSKeyValueStore::ListImpl(ListOptions options,
                                 AnyFlowReceiver<absl::Status, Key> receiver) {
  chfs_list.Increment();
  if (options.range.empty()) {
    execution::set_starting(receiver, [] {});
    execution::set_done(receiver);
    execution::set_stopping(receiver);
    return;
  }
  executor()(CHFSListTask{std::move(options.range), options.strip_prefix_length,
                      std::move(receiver)});
}

Future<kvstore::DriverPtr> CHFSKeyValueStoreSpec::DoOpen() const {
  auto driver_ptr = internal::MakeIntrusivePtr<CHFSKeyValueStore>();
  driver_ptr->spec_ = data_;
  int ret = chfs_init(NULL);
  if (ret < 0) {
    fprintf(stderr, "chfs_init failed\n");
  }
  return driver_ptr;
}

Result<kvstore::Spec> ParseCHFSUrl(std::string_view url) {
  auto driver_spec = internal::MakeIntrusivePtr<CHFSKeyValueStoreSpec>();
  driver_spec->data_.file_io_concurrency =
      Context::Resource<internal::FileIoConcurrencyResource>::DefaultSpec();
  auto parsed = internal::ParseGenericUri(url);
  assert(parsed.scheme == tensorstore::CHFSKeyValueStoreSpec::id);
  if (!parsed.query.empty()) {
    return absl::InvalidArgumentError("Query string not supported");
  }
  if (!parsed.fragment.empty()) {
    return absl::InvalidArgumentError("Fragment identifier not supported");
  }
  return {std::in_place, std::move(driver_spec),
          internal::PercentDecode(parsed.authority_and_path)};
}

}
}

TENSORSTORE_DECLARE_GARBAGE_COLLECTION_NOT_REQUIRED(
    tensorstore::CHFSKeyValueStore)

namespace {
const tensorstore::internal_kvstore::DriverRegistration<
    tensorstore::CHFSKeyValueStoreSpec>
    registration;

const tensorstore::internal_kvstore::UrlSchemeRegistration
    url_scheme_registration{tensorstore::CHFSKeyValueStoreSpec::id,
                            tensorstore::ParseCHFSUrl};
}  // namespace