#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo 'Running C# makefile test'
make -j"$(nproc)" -C "$SCRIPT_DIR"/.. test_cs
