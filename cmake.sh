#!/usr/bin/env bash

# ===== Build CMake ================================================================
wget https://github.com/Kitware/CMake/releases/download/v3.19.3/cmake-3.19.3.tar.gz
cmakever="3.19.3"
localapp_dir="${HOME}/bin/"
install_dir="${localapp_dir}/CMAKE-${cmakever}"

tar -xzvf cmake-${cmakever}.tar.gz
cd cmake-${cmakever}
./configure --prefix=${install_dir}
make -j4
make install
cd ..

# --- OPSIONAL
# buat symbolic link (shortcut) dengan nama cmake3
# ln -s ${install_dir}/bin/cmake ${localapp_dir}/cmake3
# ==================================================================================