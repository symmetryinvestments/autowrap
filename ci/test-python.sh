#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DC="${DC:-dmd}"


"$SCRIPT_DIR"/../pynih/ci.sh

DUB_CONFIGURATION=python37 make -j`nproc` test_python
pushd /tmp
dub fetch pyd --version=0.11.0
dub run pyd:setup
set +u  # or else the script below fails
source pyd_set_env_vars.sh
set -u
popd
DUB_CONFIGURATION=env make -j`nproc` test_python
dub test --build=unittest-cov --compiler="$DC"
