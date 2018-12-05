#!/bin/bash
set -euo pipefail
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
CWD=$PWD

cd $DIR
echo $CWD
echo $PWD
echo $DIR/bin/Debug/netcoreapp2.1
dub build --arch=x86_64 --force > /dev/null 2>&1
mv libcsharp-tests.so libcsharp-tests.x64.so
dub run --config=emitCSharp
dotnet build

ls -la $CWD
ls -la $PWD
ls -la $DIR/bin/Debug/netcoreapp2.1

LD_DEBUG=libs LD_LIBRARY_PATH=$DIR/bin/Debug/netcoreapp2.1 dotnet test

cd $CWD
