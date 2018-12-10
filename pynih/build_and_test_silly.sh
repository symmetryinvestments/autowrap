#!/bin/bash

set -euo pipefail

PYTHON_INCLUDE_DIR="${PYTHON_INCLUDE_DIR:-/usr/include/python3.7m}"

dub run dpp -- -shared -ofsilly.so -Isource --keep-d-files --include-path $PYTHON_INCLUDE_DIR source/python/raw.dpp silly.d
python test_silly.py
