.PHONY: test contract/libcontract.so

dpp_version = 0.4.3
dpp_pkg_dir = $(HOME)/.dub/packages/dpp-$(dpp_version)
dpp_lock = $(dpp_pkg_dir)/dpp.lock
dpp_dir = $(dpp_pkg_dir)/dpp
dpp = $(dpp_dir)/bin/d++

PYTHON_INCLUDE_DIR = $(shell python -c 'from distutils.sysconfig import get_python_inc; print(get_python_inc())')

.PHONY: test
test: contract/contract.so
	PYTHONPATH=$(shell pwd)/contract pytest -s -vv contract/tests

contract/contract.so: contract/libcontract.so
	cp $< $@


.PHONY: test contract/libcontract.so
contract/libcontract.so: source/python/raw.d
	cd contract && dub build -q


source/python/raw.d: source/python/raw.dpp $(dpp) Makefile
	$(dpp) --ignore-cursor=PyType_HasFeature --ignore-cursor=_Py_IS_TYPE --preprocess-only --include-path $(PYTHON_INCLUDE_DIR) $<


$(dpp): $(dpp_lock)
	cd $(dpp_dir) && dub build -q --build=release

$(dpp_lock):
	dub fetch dpp@$(dpp_version)
