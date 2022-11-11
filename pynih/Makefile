DC ?= dmd
dpp_version = 0.4.13

PYTHON_INCLUDE_DIR = $(shell python -c 'from distutils.sysconfig import get_python_inc; print(get_python_inc())')

.PHONY: test
test: contract/contract.so
	PYTHONPATH=$(shell pwd)/contract pytest -s -vv contract/tests

contract/contract.so: contract/libcontract.so
	cp $< $@


.PHONY: test contract/libcontract.so
contract/libcontract.so: source/python/raw.d
	cd contract && dub build -q --compiler=${DC}


source/python/raw.d: source/python/raw.dpp $(dpp) Makefile
	dub run dpp@$(dpp_version) --build=release --compiler=${DC} -- --ignore-cursor=PyType_HasFeature --ignore-cursor=stat64 --function-macros --preprocess-only --include-path $(PYTHON_INCLUDE_DIR) $<
