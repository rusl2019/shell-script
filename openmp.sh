#!/usr/bin/env bash

# ===== Build OPENMPI ==============================================================
wget https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.0.tar.gz
openmpi_ver="4.1.0"
app_dir="${HOME}/bin"
openmpi_dir="${app_dir}/OPENMPI-${openmpi_ver}"

tar -xzvf openmpi-${openmpi_ver}.tar.gz
cd openmpi-${openmpi_ver}
./configure --prefix=${openmpi_dir}
make -j4
make install
cd ..
# ==================================================================================