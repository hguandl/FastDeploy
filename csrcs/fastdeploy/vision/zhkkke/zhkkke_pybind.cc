// Copyright (c) 2022 PaddlePaddle Authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#include "fastdeploy/pybind/main.h"

namespace fastdeploy {
void BindZHKKKe(pybind11::module& m) {
  auto zhkkke_module = m.def_submodule("zhkkke", "https://github.com/ZHKKKe");
  // Bind MODNet
  pybind11::class_<vision::zhkkke::MODNet, FastDeployModel>(zhkkke_module,
                                                            "MODNet")
      .def(pybind11::init<std::string, std::string, RuntimeOption, Frontend>())
      .def("predict",
           [](vision::zhkkke::MODNet& self, pybind11::array& data) {
             auto mat = PyArrayToCvMat(data);
             vision::MattingResult res;
             self.Predict(&mat, &res);
             return res;
           })
      .def_readwrite("size", &vision::zhkkke::MODNet::size)
      .def_readwrite("alpha", &vision::zhkkke::MODNet::alpha)
      .def_readwrite("beta", &vision::zhkkke::MODNet::beta)
      .def_readwrite("swap_rb", &vision::zhkkke::MODNet::swap_rb);
}

}  // namespace fastdeploy