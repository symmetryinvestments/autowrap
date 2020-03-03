#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
"$SCRIPT_DIR"/test-python.sh
"$SCRIPT_DIR"/test-csharp.sh
make -j"$(nproc)" -C "$SCRIPT_DIR"/.. test_translation test_phobos
