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

#include <pybind11/pybind11.h>
#include <pybind11/stl.h>
// Other headers must be included after pybind11 to ensure header-order
// inclusion constraints are satisfied.

#include <string>
#include <vector>

#include "python/tensorstore/json_type_caster.h"
#include "python/tensorstore/tensorstore_module_components.h"
#include "tensorstore/internal/global_initializer.h"
#include "tensorstore/internal/metrics/collect.h"
#include "tensorstore/internal/metrics/registry.h"

namespace tensorstore {
namespace internal_python {
namespace {

std::vector<::nlohmann::json> CollectMatchingMetrics(
    std::string metric_prefix, bool include_zero_metrics) {
  std::vector<::nlohmann::json> lines;

  for (const auto& metric :
       internal_metrics::GetMetricRegistry().CollectWithPrefix(metric_prefix)) {
    if (include_zero_metrics ||
        internal_metrics::IsCollectedMetricNonZero(metric)) {
      lines.push_back(internal_metrics::CollectedMetricToJson(metric));
    }
  }

  std::sort(std::begin(lines), std::end(lines));
  return lines;
}
}  // namespace

void RegisterMetricBindings(pybind11::module_ m, Executor defer) {
  m.def("experimental_collect_matching_metrics", &CollectMatchingMetrics,
        pybind11::arg("metric_prefix") = "",
        pybind11::arg("include_zero_metrics") = false, R"(

Collects metrics with a matching prefix.

Args:
  metric_prefix: Prefix of the metric name.
  include_zero_metrics: Indicate whether zero-valued metrics are included.

Returns:
  :py:obj:`list` of a :py:obj:`dict` of metrics.

Group:
  Experimental
)");
}

TENSORSTORE_GLOBAL_INITIALIZER {
  RegisterPythonComponent(RegisterMetricBindings, /*priority=*/-1);
}

}  // namespace internal_python
}  // namespace tensorstore
