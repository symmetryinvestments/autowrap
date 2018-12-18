#!/bin/bash

set -euo pipefail

DC="${DC:-dmd}"
TRAVIS="${TRAVIS:-}"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"
PYTHON_INCLUDE_DIR="${PYTHON_INCLUDE_DIR:-/usr/include/python3.7m}"


if [ "$DC" = "ldc2" ]; then
    # skip tests for ldc 1.12.0
    exit 0
fi

cd "$SCRIPT_DIR"
make

if [[ -z "${TRAVIS}" ]]; then
    dub test -q
else
    dub run -c unittest-travis --build=unittest-cov
fi
