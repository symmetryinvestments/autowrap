.PHONY: test

test: contract.so
	PYTHONPATH=$(PWD) pytest

contract.so: libcontract.so
	cp $< $@

libcontract.so: dub.sdl dub.selections.json source/scalars.d ../libpython.a
	dub build -q

../libpython.a:
	make -C ..
