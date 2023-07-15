workspace(
    name = "tensorstore",
)

load("//:external.bzl", "tensorstore_dependencies")

load("//:pkg_config_repository.bzl", "pkg_config_repository")

pkg_config_repository(
  name = "chfs",
  packages = ["chfs"],
)

tensorstore_dependencies()

register_toolchains("@local_config_python//:py_toolchain")
