# Makefile to drive the tests

DUB_CONFIGURATION ?= python37

.PHONY: test_simple examples/simple/libsimple.so

all: test_simple
test: test_simple

test_simple: tests/test_simple.py examples/simple/simple.so
	PYTHONPATH=$(PWD)/examples/simple pytest -s -vv $<

examples/simple/simple.so: examples/simple/libsimple.so
	cp $^ $@

examples/simple/libsimple.so: examples/simple/dub.sdl examples/simple/dub.selections.json
	cd examples/simple && dub build -c $(DUB_CONFIGURATION)
