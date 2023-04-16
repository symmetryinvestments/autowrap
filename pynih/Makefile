DC ?= dmd

UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
	shared_ext := .so
endif
ifeq ($(UNAME_S),Darwin)
	shared_ext := .dylib
endif

PYTHON_INCLUDE_DIR = $(shell python -c 'from distutils.sysconfig import get_python_inc; print(get_python_inc())')

.PHONY: test
test: contract/contract.so
	PYTHONPATH=$(shell pwd)/contract pytest -s -vv contract/tests

contract/contract.so: contract/libcontract$(shared_ext)
	cp $< $@


.PHONY: test contract/libcontract$(shared_ext)
contract/libcontract$(shared_ext):
	cd contract && dub build -v --compiler=${DC}

preprocess: generated/python/impl.i

generated/python/impl.i: source/python/_impl.c
	mkdir -p $(@D)
	clang -include /Users/john/dlang/ldc-1.32.0/import/importc.h -fno-blocks -std=c11 -I /opt/homebrew/Cellar/python@3.11/3.11.3/Frameworks/Python.framework/Versions/3.11/include/python3.11 -E source/python/_impl.c -o - | ./postpreprocess.d > generated/python/impl.i

.PHONY: clean
clean:
	rm -rf generated
