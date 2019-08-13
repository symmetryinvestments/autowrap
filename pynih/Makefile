.PHONY: test

dpp_version = 0.3.1
dpp_pkg_dir = $(HOME)/.dub/packages/dpp-$(dpp_version)
dpp_lock = $(dpp_pkg_dir)/dpp.lock
dpp_dir = $(dpp_pkg_dir)/dpp
dpp = $(dpp_dir)/bin/d++

PYTHON_INCLUDE_DIR = $(shell python -c 'from distutils.sysconfig import get_python_inc; print(get_python_inc())')

test: contract/contract.so
	PYTHONPATH=$(PWD)/contract pytest -s -vv contract/tests


contract/contract.so: contract/libcontract.so
	cp $< $@


contract/libcontract.so: contract/dub.sdl contract/dub.selections.json contract/source/contract/main.d contract/source/contract/scalars.d contract/source/contract/udt.d dub.sdl dub.selections.json source/python/raw.d source/python/package.d source/python/cooked.d source/python/boilerplate.d
	cd contract && dub build -q


source/python/raw.d: source/python/raw.dpp $(dpp)
	$(dpp) --preprocess-only --include-path $(PYTHON_INCLUDE_DIR) source/python/raw.dpp


$(dpp): $(dpp_lock)
	cd $(dpp_dir) && dub build -q

$(dpp_lock):
	dub fetch dpp --version=$(dpp_version)
