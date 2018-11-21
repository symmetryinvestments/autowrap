#!/bin/bash

set -euo pipefail

PYTHON_INCLUDE_DIR="${PYTHON_INCLUDE_DIR:-/usr/include/python3.7m}"

d++ -shared -ofsilly.so --keep-d-files --include-path $PYTHON_INCLUDE_DIR python.dpp silly.d
python test_silly.py
