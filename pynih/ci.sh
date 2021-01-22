#!/bin/bash

set -euo pipefail

DC="${DC:-dmd}"
TRAVIS="${TRAVIS:-}"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"
PYTHON_INCLUDE_DIR="${PYTHON_INCLUDE_DIR:-/usr/include/python3.9}"


if [ "$DC" = "ldc2" ]; then
    # skip tests for ldc 1.12.0
    exit 0
fi

cd "$SCRIPT_DIR"
make -j"$(nproc)"
