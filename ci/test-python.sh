#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DC="${DC:-dmd}"
PYTHON_LIB_DIR="${PYTHON_LIB_DIR:-/usr/lib}"

echo "Testing with $DC compiler"

# echo 'Testing pynih'
"$SCRIPT_DIR"/../pynih/ci.sh

# FIXME - Use pythono38 when it exists
# DUB_CONFIGURATION=python38 make -j"$(nproc)" test_python

# FIXME - use env when it works (broken until pyd tags the latest fix)
# pushd /tmp
# dub fetch pyd --version=0.13.0
# dub run pyd:setup
# set +u  # or else the script below fails
# source pyd_set_env_vars.sh
# set -u
# popd
# DUB_CONFIGURATION=env make -j"$(nproc)" test_python

echo 'Running Python makefile test'
echo "And the lib dir is $PYTHON_LIB_DIR"
make -j"$(nproc)" test_python  # FIXME - restore the two above instad of this line

echo 'Running autowrap unit tests'
PYTHON_LIB_DIR="$PYTHON_LIB_DIR" dub test -q --build=unittest-cov --compiler="$DC"
