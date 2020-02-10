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

TEST_SIMPLE_PY := $(shell pwd)/../../tests/test_simple.py


define python-module

lib/$2/$1.so: lib/$2/lib$1.so
	@cp $$^ $$@

.PHONY: lib/$2/lib$1.so
lib/$2/lib$1.so:
	@cd $1 && dub build -q -c $3

endef

define python-module-pyd
$(call python-module,$1,pyd,$(DUB_CONFIGURATION))
endef

define python-module-pynih
$(call python-module,$1,pynih,pynih)
endef



all: test_simple_python

.PHONY: test_simple_python
test_simple_python: test_simple_pyd test_simple_pynih


.PHONY: test_simple_pyd
test_simple_pyd: $(TEST_SIMPLE_PY) lib/pyd/prefix.so lib/pyd/adder.so lib/pyd/structs.so lib/pyd/api.so lib/pyd/wrap_all.so
	PYTHONPATH=$(shell pwd)/lib/pyd PYD=1 pytest -s -vv $<

.PHONY: test_simple_pynih
test_simple_pynih: $(TEST_SIMPLE_PY) $(shell pwd)/../../pynih/source/python/raw.d lib/pynih/prefix.so lib/pynih/adder.so lib/pynih/structs.so lib/pynih/api.so lib/pynih/wrap_all.so
	PYTHONPATH=$(shell pwd)/lib/pynih PYNIH=1 pytest -s -vv $<


$(eval $(call python-module-pyd,prefix))
$(eval $(call python-module-pynih,prefix))
$(eval $(call python-module-pyd,adder))
$(eval $(call python-module-pynih,adder))
$(eval $(call python-module-pyd,structs))
$(eval $(call python-module-pynih,structs))
$(eval $(call python-module-pyd,api))
$(eval $(call python-module-pynih,api))
$(eval $(call python-module-pyd,wrap_all))
$(eval $(call python-module-pynih,wrap_all))
