# Makefile to drive the tests

DUB_CONFIGURATION ?= python37

.PHONY: test test_simple test_issues examples/simple/libsimple.so examples/issues/libissues.so

all: test
test: test_simple test_issues

test_simple: tests/test_simple.py tests/test_issues.py examples/simple/simple.so
	PYTHONPATH=$(PWD)/examples/simple pytest -s -vv tests/test_simple.py

examples/simple/simple.so: examples/simple/libsimple.so
	cp $^ $@

examples/simple/libsimple.so: examples/simple/dub.sdl examples/simple/dub.selections.json
	cd examples/simple && dub build -c $(DUB_CONFIGURATION)

test_issues: tests/test_issues.py tests/test_issues.py examples/issues/issues.so
	PYTHONPATH=$(PWD)/examples/issues pytest -s -vv tests/test_issues.py

examples/issues/issues.so: examples/issues/libissues.so
	cp $^ $@

examples/issues/libissues.so: examples/issues/dub.sdl examples/issues/dub.selections.json
	cd examples/issues && dub build -c $(DUB_CONFIGURATION)
