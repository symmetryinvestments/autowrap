#!/bin/bash

set -euo pipefail

DC="${DC:-dmd}"
TRAVIS="${TRAVIS:-}"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"


cd "$SCRIPT_DIR"
if [ -z "${CI+x}" ]; then
    make -j"$(nproc)"
else
    make
fi
