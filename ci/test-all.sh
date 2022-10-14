#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
"$SCRIPT_DIR"/test-python.sh
# FIXME - stopped working in CI after dmd 2.095.0 -> dmd 2.100.2
#"$SCRIPT_DIR"/test-csharp.sh  # FIXME
make -C "$SCRIPT_DIR"/.. test_translation test_phobos
