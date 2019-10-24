#!/bin/bash
set -euo pipefail
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
CWD=$PWD

cd $DIR

rm -f Wrapper.cs libcsharp-tests.so libcsharp-tests.x64.so
dub build -q --arch=x86_64
cp libcsharp-tests.so libcsharp-tests.x64.so
dub run -q --config=emitCSharp
dotnet build
dotnet test
