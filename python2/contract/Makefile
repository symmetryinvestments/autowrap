.PHONY: test

test: contract.so
	PYTHONPATH=$(PWD) pytest -s -vv

contract.so: libcontract.so
	cp $< $@

libcontract.so: dub.sdl dub.selections.json source/contract/main.d source/contract/scalars.d source/contract/udt.d ../libpython.a
	dub build -q

../libpython.a: ../source/python/bindings.dpp ../source/python/util.d
	make -C ..
