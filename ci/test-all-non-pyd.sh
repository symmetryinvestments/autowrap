#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

"$SCRIPT_DIR"/../pynih/ci.sh
make -C "$SCRIPT_DIR"/.. ut test_python_pynih test_translation
