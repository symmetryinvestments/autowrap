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


define test-package
.PHONY: test_std_$1
test_std_$1: test_std_$1_pyd test_std_$1_pynih

.PHONY: test_std_$1_pyd
test_std_$1_pyd: tests/test_std_$1.py std_$1/lib/pyd/std_$1.so
	PYTHONPATH=$(shell pwd)/std_$1/lib/pyd PYD=1 pytest -s -vv $$<

std_$1/lib/pyd/std_$1.so: std_$1/lib/pyd/libstd_$1.so
	@cp $$^ $$@

.PHONY: std_$1/lib/pyd/libstd_$1.so
std_$1/lib/pyd/libstd_$1.so:
	@cd std_$1 && dub build -q -c $(DUB_CONFIGURATION)

std_$1/dub.selections.json:
	@cd std_$1 && dub upgrade -q

.PHONY: test_std_$1_pynih
test_std_$1_pynih: tests/test_std_$1.py std_$1/lib/pynih/std_$1.so
	PYTHONPATH=$(shell pwd)/std_$1/lib/pynih PYNIH=1 pytest -s -vv $$<

std_$1/lib/pynih/std_$1.so: std_$1/lib/pynih/libstd_$1.so
	@cp $$^ $$@

.PHONY: std_$1/lib/pynih/libstd_$1.so
std_$1/lib/pynih/libstd_$1.so: ../../pynih/source/python/raw.d
	@cd std_$1 && dub build -q -c pynih
endef


.PHONY: all
all: test_std_datetime test_std_file test_std_math test_std_mmfile test_std_net \
test_std_numeric test_std_process test_std_random test_std_stdio test_std_xml


# pynih needs this first and foremost
pynih/source/python/raw.d: ../../pynih/Makefile ../../pynih/source/python/raw.dpp
	make -C ../../pynih source/python/raw.d


$(eval $(call test-package,datetime))
$(eval $(call test-package,file))
$(eval $(call test-package,math))
$(eval $(call test-package,mmfile))
$(eval $(call test-package,net))
$(eval $(call test-package,numeric))
$(eval $(call test-package,process))
$(eval $(call test-package,random))
$(eval $(call test-package,stdio))
$(eval $(call test-package,xml))
$(eval $(call test-package,uni))
