# Copyright (c) 2022 PaddlePaddle Authors. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

include(ExternalProject)

set(ONNXRUNTIME_PROJECT "extern_onnxruntime")
set(ONNXRUNTIME_PREFIX_DIR ${THIRD_PARTY_PATH}/onnxruntime)
set(ONNXRUNTIME_SOURCE_DIR
    ${THIRD_PARTY_PATH}/onnxruntime/src/${ONNXRUNTIME_PROJECT})
set(ONNXRUNTIME_INSTALL_DIR ${THIRD_PARTY_PATH}/install/onnxruntime)
set(ONNXRUNTIME_INC_DIR
    "${ONNXRUNTIME_INSTALL_DIR}/include"
    CACHE PATH "onnxruntime include directory." FORCE)
set(ONNXRUNTIME_LIB_DIR
    "${ONNXRUNTIME_INSTALL_DIR}/lib"
    CACHE PATH "onnxruntime lib directory." FORCE)
set(CMAKE_BUILD_RPATH "${CMAKE_BUILD_RPATH}" "${ONNXRUNTIME_LIB_DIR}")

set(ONNXRUNTIME_VERSION "1.11.1")
set(ONNXRUNTIME_URL_PREFIX "https://bj.bcebos.com/paddle2onnx/libs/")

if(WIN32)
  if(WITH_GPU)
    set(ONNXRUNTIME_FILENAME "onnxruntime-win-x64-gpu-${ONNXRUNTIME_VERSION}.zip")
  else()
    set(ONNXRUNTIME_FILENAME "onnxruntime-win-x64-${ONNXRUNTIME_VERSION}.zip")
  endif()
elseif(APPLE)
  if(CMAKE_HOST_SYSTEM_PROCESSOR MATCHES "arm64")
    set(ONNXRUNTIME_FILENAME "onnxruntime-osx-arm64-${ONNXRUNTIME_VERSION}.tgz")
  else()
    set(ONNXRUNTIME_FILENAME "onnxruntime-osx-x86_64-${ONNXRUNTIME_VERSION}.tgz")
  endif()
else()
  if(WITH_GPU)
    set(ONNXRUNTIME_FILENAME "onnxruntime-linux-x64-gpu-${ONNXRUNTIME_VERSION}.tgz")
  else()
    set(ONNXRUNTIME_FILENAME "onnxruntime-linux-x64-${ONNXRUNTIME_VERSION}.tgz")
  endif()
endif()
set(ONNXRUNTIME_URL "${ONNXRUNTIME_URL_PREFIX}${ONNXRUNTIME_FILENAME}")

include_directories(${ONNXRUNTIME_INC_DIR}
)# For ONNXRUNTIME code to include internal headers.

if(WIN32)
  set(ONNXRUNTIME_LIB
      "${ONNXRUNTIME_INSTALL_DIR}/lib/onnxruntime.lib"
      CACHE FILEPATH "ONNXRUNTIME static library." FORCE)
elseif(APPLE)
  set(ONNXRUNTIME_LIB
      "${ONNXRUNTIME_INSTALL_DIR}/lib/libonnxruntime.dylib"
      CACHE FILEPATH "ONNXRUNTIME static library." FORCE)
else()
  set(ONNXRUNTIME_LIB
      "${ONNXRUNTIME_INSTALL_DIR}/lib/libonnxruntime.so"
      CACHE FILEPATH "ONNXRUNTIME static library." FORCE)
endif()

ExternalProject_Add(
  ${ONNXRUNTIME_PROJECT}
  ${EXTERNAL_PROJECT_LOG_ARGS}
  URL ${ONNXRUNTIME_URL}
  PREFIX ${ONNXRUNTIME_PREFIX_DIR}
  DOWNLOAD_NO_PROGRESS 1
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  UPDATE_COMMAND ""
  INSTALL_COMMAND
    ${CMAKE_COMMAND} -E remove_directory ${ONNXRUNTIME_INSTALL_DIR} &&
    ${CMAKE_COMMAND} -E make_directory ${ONNXRUNTIME_INSTALL_DIR} &&
    ${CMAKE_COMMAND} -E rename ${ONNXRUNTIME_SOURCE_DIR}/lib/ ${ONNXRUNTIME_INSTALL_DIR}/lib &&
    ${CMAKE_COMMAND} -E copy_directory ${ONNXRUNTIME_SOURCE_DIR}/include
    ${ONNXRUNTIME_INC_DIR}
  BUILD_BYPRODUCTS ${ONNXRUNTIME_LIB})

add_library(external_onnxruntime STATIC IMPORTED GLOBAL)
set_property(TARGET external_onnxruntime PROPERTY IMPORTED_LOCATION ${ONNXRUNTIME_LIB})
add_dependencies(external_onnxruntime ${ONNXRUNTIME_PROJECT})