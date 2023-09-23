// Copyright 2023 The TensorStore Authors
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#ifndef TENSORSTORE_KVSTORE_S3_CHAINED_CREDENTIAL_PROVIDER
#define TENSORSTORE_KVSTORE_S3_CHAINED_CREDENTIAL_PROVIDER

#include <memory>
#include <vector>

#include "tensorstore/kvstore/s3/aws_credential_provider.h"

namespace tensorstore {
namespace internal_kvstore_s3 {

class ChainedCredentialProvider : public AwsCredentialProvider {
private:
  std::vector<std::unique_ptr<AwsCredentialProvider>> providers_;

public:
  ChainedCredentialProvider(std::vector<std::unique_ptr<AwsCredentialProvider>> providers)
    : providers_(std::move(providers)) {}

  Result<AwsCredentials> GetCredentials() override;
};

} // namespace tensorstore
} // namespace internal_kvstore_s3

#endif // TENSORSTORE_KVSTORE_S3_CHAINED_CREDENTIAL_PROVIDER