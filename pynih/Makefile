DC ?= $(shell echo $$DC)
PYTHON ?= python
IMPORTC_H_PATH ?= $(shell echo $$IMPORTC_H_PATH)

SHELL=/bin/bash -o pipefail

UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
	shared_ext := .so
endif
ifeq ($(UNAME_S),Darwin)
	shared_ext := .dylib
endif

PYTHON_INCLUDE_DIR = $(shell $(PYTHON) -c 'from distutils.sysconfig import get_python_inc; print(get_python_inc())')

.PHONY: test
test: contract/contract.so
	PYTHONPATH=$(shell pwd)/contract pytest -s -vv contract/tests

contract/contract.so: contract/libcontract$(shared_ext)
	cp $< $@

.PHONY: test contract/libcontract$(shared_ext)
contract/libcontract$(shared_ext):
	cd contract && dub build -q --compiler=${DC}

preprocess: generated/python/impl.i

generated/python/impl.i: source/python/_impl.c
	mkdir -p $(@D)
	clang -include $(IMPORTC_H_PATH) -fno-blocks -std=c11 -I $(PYTHON_INCLUDE_DIR) -E source/python/_impl.c -o - | ./postpreprocess.d > generated/python/impl.i

.PHONY: clean
clean:
	rm -rf generated contract/contract.so contract/libcontract$(shared_ext)
