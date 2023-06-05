#!/bin/bash

set -euo pipefail

DC="${DC:-dmd}"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"

cd "$SCRIPT_DIR"
make
