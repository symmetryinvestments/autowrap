libpython.a: dub.sdl dub.selections.json source/python/raw.d source/python/package.d source/python/cooked.d
	dub build -q


source/python/raw.d: source/python/raw.dpp ~/.dub/packages/dpp-0.0.9
	dub run dpp -- --preprocess-only --include-path $(PYTHON_INCLUDE_DIR) source/python/raw.dpp


~/.dub/packages/dpp-0.0.9:
	dub fetch dpp --version=0.0.9
