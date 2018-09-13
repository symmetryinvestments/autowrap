#!/bin/sh

rm -f libautowrap.*.so
dub build --arch=x86 --force
mv libautowrap-support.so libautowrap.x86.so
dub build --arch=x86_64 --force
mv libautowrap-support.so libautowrap.x64.so
dotnet build
dotnet pack
