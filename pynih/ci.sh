#!/bin/bash

set -euo pipefail
DC="${DC:-dmd}"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"
PYTHON_INCLUDE_DIR="${PYTHON_INCLUDE_DIR:-/usr/include/python3.7m}"


if [ "$DC" = "ldc2" ]; then
    # skip tests for ldc 1.12.0
    exit 0
fi

cd "$SCRIPT_DIR"/contract
make
cd "$SCRIPT_DIR"
ls
dub run -c unittest-travis --build=unittest-cov
