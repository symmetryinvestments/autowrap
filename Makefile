# Makefile to drive the tests

export PYTHON_LIB_DIR ?= /usr/lib
export DUB_CONFIGURATION ?= env
export PYD_LIBPYTHON_DIR ?= /usr/lib
export PYD_LIBPYTHON ?= python3.8
export PYD_D_VERSION_1 ?= Python_2_4_Or_Later
export PYD_D_VERSION_2 ?= Python_2_5_Or_Later
export PYD_D_VERSION_3 ?= Python_2_6_Or_Later
export PYD_D_VERSION_4 ?= Python_2_7_Or_Later
export PYD_D_VERSION_5 ?= Python_3_0_Or_Later
export PYD_D_VERSION_6 ?= Python_3_1_Or_Later
export PYD_D_VERSION_7 ?= Python_3_2_Or_Later
export PYD_D_VERSION_8 ?= Python_3_3_Or_Later
export PYD_D_VERSION_9 ?= Python_3_4_Or_Later
export PYD_D_VERSION_10 ?= Python_3_5_Or_Later
export PYD_D_VERSION_11 ?= Python_3_6_Or_Later
export PYD_D_VERSION_12 ?= Python_3_7_Or_Later
export PYD_D_VERSION_13 ?= Python_3_8_Or_Later

.PHONY: all
all: test
.PHONY: test
test: test_python test_cs test_translation test_phobos
.PHONY: test_python
test_python: test_python_pyd test_python_pynih
.PHONY: test_python_pyd
test_python_pyd:   test_simple_pyd   test_pyd_pyd   test_issues_pyd   test_numpy_pyd
.PHONY: test_python_pynih
test_python_pynih: test_simple_pynih test_pyd_pynih test_issues_pynih
.PHONY: test_phobos  # new Phobos target, reflects on individual Phobos modules / packages
test_phobos:
	make -C examples/phobos
.PHONY: test_cs
test_cs: test_simple_cs
.PHONY: test_translation
test_translation: test_translation_ut test_transl_simple_cs
.PHONY: test_translation_ut
test_translation_ut:
	cd translate && PYTHONPATH=$(PWD)/translate pytest -s -vv

.PHONY: clean
clean:
	git clean -xffd

.PHONY: test_simple_pyd
test_simple_pyd:
	make -C examples/simple test_simple_pyd

.PHONY: test_simple_pynih
test_simple_pynih: pynih/source/python/raw.d
	make -C examples/simple test_simple_pynih


# Runs the generated C# test for the simple example
.PHONY: test_transl_simple_cs
test_transl_simple_cs: examples/simple/lib/csharp/libsimple.x64.so tests/test_transl_simple_cs/Simple.cs tests/test_transl_simple_cs/TestSimple.cs
	@cd tests/test_transl_simple_cs && \
	dotnet build test_simple_cs.csproj && \
	dotnet test test_simple_cs.csproj

tests/test_transl_simple_cs/TestSimple.cs: tests/test_simple.py translate/pytest_translate translate/backend/csharp.py translate/python_to_ir.py translate/ir.py
	translate/pytest_translate tests/test_simple.py $@

tests/test_transl_simple_cs/Simple.cs: examples/simple/Simple.cs
	cp $^ $@


.PHONY: test_simple_cs
test_simple_cs: examples/simple/lib/csharp/libsimple.x64.so examples/simple/Simple.cs
	@cd tests/test_simple_cs && \
	dotnet build test_simple_cs.csproj && \
	dotnet test test_simple_cs.csproj

examples/simple/lib/csharp/libsimple.x64.so: examples/simple/lib/csharp/libsimple.so
	@cp $^ $@

.PHONY: examples/simple/lib/csharp/libsimple.so
examples/simple/lib/csharp/libsimple.so: examples/simple/dub.sdl examples/simple/dub.selections.json
	@cd examples/simple && dub build -q -c csharp

examples/simple/Simple.cs: examples/simple/lib/csharp/libsimple.so
	@cd examples/simple && dub run -q -c emitCSharp

pynih/source/python/raw.d: pynih/Makefile pynih/source/python/raw.dpp
	make -C pynih source/python/raw.d


.PHONY: test_issues_pyd
test_issues_pyd: tests/test_issues.py examples/issues/lib/pyd/issues.so
	PYTHONPATH=$(PWD)/examples/issues/lib/pyd PYD=1 pytest -s -vv $<

examples/issues/lib/pyd/issues.so: examples/issues/lib/pyd/libissues.so
	@cp $^ $@

.PHONY: examples/issues/lib/pyd/libissues.so
examples/issues/lib/pyd/libissues.so:
	@cd examples/issues && dub build -q -c $(DUB_CONFIGURATION)

.PHONY: test_issues_pynih
test_issues_pynih: tests/test_issues.py examples/issues/lib/pynih/issues.so
	PYTHONPATH=$(PWD)/examples/issues/lib/pynih PYNIH=1 pytest -s -vv $<

examples/issues/lib/pynih/issues.so: examples/issues/lib/pynih/libissues.so
	@cp $^ $@

.PHONY: examples/issues/lib/pynih/libissues.so
examples/issues/lib/pynih/libissues.so: pynih/source/python/raw.d
	@cd examples/issues && dub build -q -c pynih


examples/issues/dub.selections.json:
	@cd examples/issues && dub upgrade -q

.PHONY: test_pyd_pyd
test_pyd_pyd: tests/test_pyd.py examples/pyd/lib/pyd/pyd.so
	PYTHONPATH=$(PWD)/examples/pyd/lib/pyd PYD=1 pytest -s -vv $<

examples/pyd/lib/pyd/pyd.so: examples/pyd/lib/pyd/libpydtests.so
	@cp $^ $@

.PHONY: examples/pyd/lib/pyd/libpydtests.so
examples/pyd/lib/pyd/libpydtests.so:
	@cd examples/pyd && dub build -q -c $(DUB_CONFIGURATION)

.PHONY: test_pyd_pynih
test_pyd_pynih: tests/test_pyd.py examples/pyd/lib/pynih/pyd.so
	PYTHONPATH=$(PWD)/examples/pyd/lib/pynih PYNIH=1 pytest -s -vv $<

examples/pyd/lib/pynih/pyd.so: examples/pyd/lib/pynih/libpydtests.so
	@cp $^ $@

.PHONY: examples/pyd/lib/pynih/libpydtests.so
examples/pyd/lib/pynih/libpydtests.so: pynih/source/python/raw.d
	@cd examples/pyd && dub build -q -c pynih

.PHONY: test_numpy_pyd
test_numpy_pyd: tests/test_numpy.py examples/numpy/lib/pyd/numpytests.so
	PYTHONPATH=$(PWD)/examples/numpy/lib/pyd pytest -s -vv $<

examples/numpy/lib/pyd/numpytests.so: examples/numpy/lib/pyd/libnumpy.so
	@cp $^ $@

.PHONY: examples/numpy/lib/pyd/libnumpy.so
examples/numpy/lib/pyd/libnumpy.so:
	@cd examples/numpy && dub build -q -c $(DUB_CONFIGURATION)

examples/numpy/dub.selections.json:
	@cd examples/numpy && dub upgrade -q

.PHONY: test_numpy_pynih
test_numpy_pynih: tests/test_numpy.py examples/numpy/lib/pynih/numpytests.so
	PYTHONPATH=$(PWD)/examples/numpy/lib/pynih pytest -s -vv $<

examples/numpy/lib/pynih/numpytests.so: examples/numpy/lib/pynih/libnumpy.so
	@cp $^ $@

.PHONY: examples/numpy/lib/pynih/libnumpy.so
examples/numpy/lib/pynih/libnumpy.so: pynih/source/python/raw.d
	@cd examples/numpy && dub build -q -c pynih
