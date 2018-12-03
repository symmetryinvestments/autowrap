libpython.a: dub.sdl dub.selections.json source/python/bindings.d source/python/package.d source/python/util.d
	dub build -q


source/python/bindings.d: source/python/bindings.dpp ~/.dub/packages/dpp-0.0.9
	dub run dpp -- --preprocess-only --include-path $(PYTHON_INCLUDE_DIR) source/python/bindings.dpp


~/.dub/packages/dpp-0.0.9:
	dub fetch dpp --version=0.0.9
