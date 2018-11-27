#!/bin/bash

set -euo pipefail

PYTHON_INCLUDE_DIR="${PYTHON_INCLUDE_DIR:-/usr/include/python3.7m}"

d++ -shared -ofsilly.so -Isource --keep-d-files --include-path $PYTHON_INCLUDE_DIR source/python/bindings.dpp silly.d
python test_silly.py
