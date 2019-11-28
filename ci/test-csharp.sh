#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo 'Running C# script test'
"$SCRIPT_DIR"/../csharp/tests/test.sh
echo 'Running C# makefile test'
make -j"$(nproc)" -C "$SCRIPT_DIR"/.. test_cs
