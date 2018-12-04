#!/bin/sh
set -euo pipefail
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
CWD=$PWD

cd $DIR
rm -f csharp-tests
rm -f libcsharp*.so
dub build --arch=x86_64 --force > /dev/null 2>&1
mv libcsharp-tests.so libcsharp-tests.x64.so
rm -f libcsharp-tests.so
dub run --config=emitCSharp
dotnet build
LD_LIBRARY_PATH=$DIR dotnet vstest ./bin/Debug/netcoreapp2.1/tests.dll
cd $CWD
