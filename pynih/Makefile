.PHONY: test

dpp_version = 0.0.9
dpp_dir = $(HOME)/.dub/packages/dpp-$(dpp_version)/dpp

ifndef PYTHON_INCLUDE_DIR
$(error PYTHON_INCLUDE_DIR is not set)
endif

test: contract/contract.so
	PYTHONPATH=$(PWD)/contract pytest -s -vv contract/tests


contract/contract.so: contract/libcontract.so
	cp $< $@


contract/libcontract.so: contract/dub.sdl contract/dub.selections.json contract/source/contract/main.d contract/source/contract/scalars.d contract/source/contract/udt.d libpython.a
	cd contract && dub build -q


libpython.a: dub.sdl dub.selections.json source/python/raw.d source/python/package.d source/python/cooked.d
	dub build -q


source/python/raw.d: source/python/raw.dpp $(dpp_dir)
	dub run -q dpp -- --preprocess-only --include-path $(PYTHON_INCLUDE_DIR) source/python/raw.dpp


$(dpp_dir):
	dub fetch dpp --version=$(dpp_version)
