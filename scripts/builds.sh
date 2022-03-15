#! /bin/bash

# The goal is for this script to set up my development environment as
# completely as possible

# Path assumptions:
# - git
# - g++


_0=$(dirname "$0")
_0=$(realpath "$_0")
DOTFILES=$(dirname "$_0")



###############################################################################
# Build CMAKE
###############################################################################

mkdir -p ${DOTFILES}/build/cmake
cd ${DOTFILES}/build/cmake
wget 'https://github.com/Kitware/CMake/releases/download/v3.22.2/cmake-3.22.2.tar.gz'
tar -xfv cmake-3.22.2.tar.gz


###############################################################################
# Build NeoVim
###############################################################################

