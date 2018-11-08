#!/bin/sh
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

rm -f csharp
rm -f libcsharp*.so
dub build --arch=x86 --force
mv libcsharp.so libcsharp.x86.so
dub build --arch=x86_64 --force > /dev/null 2>&1
mv libcsharp.so libcsharp.x64.so
dub run --config=emitCSharp
echo $DIR
LD_LIBRARY_PATH=$DIR dotnet run
