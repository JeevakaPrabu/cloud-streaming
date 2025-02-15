dnl BSD 3-Clause License
dnl
dnl Copyright (C) 2020, Intel Corporation
dnl All rights reserved.
dnl
dnl Redistribution and use in source and binary forms, with or without
dnl modification, are permitted provided that the following conditions are met:
dnl
dnl * Redistributions of source code must retain the above copyright notice, this
dnl   list of conditions and the following disclaimer.
dnl
dnl * Redistributions in binary form must reproduce the above copyright notice,
dnl   this list of conditions and the following disclaimer in the documentation
dnl   and/or other materials provided with the distribution.
dnl
dnl * Neither the name of the copyright holder nor the names of its
dnl   contributors may be used to endorse or promote products derived from
dnl   this software without specific prior written permission.
dnl
dnl THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
dnl AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
dnl IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
dnl DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
dnl FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
dnl DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
dnl SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
dnl CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
dnl OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
dnl OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
dnl
include(begin.m4)

ifelse(OS_NAME,centos,ifelse(OS_VERSION,7,`dnl
include(centos-scl.m4)
'))
include(cmake.m4)
include(libva2.m4)

DECLARE(`MSDK_VER',intel-mediasdk-23.1.0)
DECLARE(`MSDK_SRC_REPO',https://github.com/Intel-Media-SDK/MediaSDK/archive/MSDK_VER.tar.gz)
DECLARE(`MSDK_BUILD_SAMPLES',OFF)

ifelse(OS_NAME,ubuntu,`dnl
define(`MSDK_BUILD_DEPS',`ca-certificates gcc g++ make pkg-config wget')
')

ifelse(OS_NAME,centos,`dnl
define(`MSDK_BUILD_DEPS',`ifelse(OS_VERSION,7,devtoolset-9-gcc devtoolset-9-gcc-c++,gcc gcc-c++) dnl
  make pkg-config wget')
')

define(`BUILD_MSDK',`dnl
# build media sdk
ARG MSDK_REPO=MSDK_SRC_REPO
RUN cd BUILD_HOME && \
  wget -O - ${MSDK_REPO} | tar xz
RUN cd BUILD_HOME/MediaSDK-MSDK_VER && \
  mkdir -p build && cd build && \
  ifelse(OS_NAME,centos,ifelse(OS_VERSION,7,scl enable devtoolset-9 -- ))cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=BUILD_PREFIX \
    -DCMAKE_INSTALL_LIBDIR=BUILD_LIBDIR \
    -DBUILD_SAMPLES=MSDK_BUILD_SAMPLES \
    -DBUILD_TUTORIALS=OFF \
    .. && \
  make -j$(nproc) && \
  make install DESTDIR=BUILD_DESTDIR && \
  make install
')

REG(MSDK)

include(end.m4)dnl
