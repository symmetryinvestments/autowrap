DC ?= dmd
dpp_version = 0.4.13

PYTHON_INCLUDE_DIR = $(shell python -c 'from distutils.sysconfig import get_python_inc; print(get_python_inc())')

.PHONY: test
test: contract/contract.so
	PYTHONPATH=$(shell pwd)/contract pytest -s -vv contract/tests

contract/contract.so: contract/libcontract.so
	cp $< $@


.PHONY: test contract/libcontract.so
contract/libcontract.so:
	cd contract && dub build -q --compiler=${DC}
