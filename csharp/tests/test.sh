#!/bin/bash
set -euo pipefail
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
CWD=$PWD

cd $DIR

dub build --arch=x86_64 --force > /dev/null 2>&1
cp libcsharp-tests.so libcsharp-tests.x64.so
dub run --config=emitCSharp
dotnet build
dotnet test
