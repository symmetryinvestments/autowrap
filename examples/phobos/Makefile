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
all: test_std_datetime test_std_file


pynih/source/python/raw.d: ../../pynih/Makefile ../../pynih/source/python/raw.dpp
	make -C ../../pynih source/python/raw.d


# start std_datetime
.PHONY: test_std_datetime
test_std_datetime: test_std_datetime_pyd test_std_datetime_pynih

.PHONY: test_std_datetime_pyd
test_std_datetime_pyd: tests/test_std_datetime.py std_datetime/lib/pyd/std_datetime.so
	PYTHONPATH=$(shell pwd)/std_datetime/lib/pyd PYD=1 pytest -s -vv $<

std_datetime/lib/pyd/std_datetime.so: std_datetime/lib/pyd/libstd_datetime.so
	@cp $^ $@

.PHONY: std_datetime/lib/pyd/libstd_datetime.so
std_datetime/lib/pyd/libstd_datetime.so:
	@cd std_datetime && dub build -q -c $(DUB_CONFIGURATION)

std_datetime/dub.selections.json:
	@cd std_datetime && dub upgrade -q

.PHONY: test_std_datetime_pynih
test_std_datetime_pynih: tests/test_std_datetime.py std_datetime/lib/pynih/std_datetime.so
	PYTHONPATH=$(shell pwd)/std_datetime/lib/pynih PYNIH=1 pytest -s -vv $<

std_datetime/lib/pynih/std_datetime.so: std_datetime/lib/pynih/libstd_datetime.so
	@cp $^ $@

.PHONY: std_datetime/lib/pynih/libstd_datetime.so
std_datetime/lib/pynih/libstd_datetime.so: ../../pynih/source/python/raw.d
	@cd std_datetime && dub build -q -c pynih
#end std_datetime


# start std_file
.PHONY: test_std_file
test_std_file: test_std_file_pyd test_std_file_pynih

.PHONY: test_std_file_pyd
test_std_file_pyd: tests/test_std_file.py std_file/lib/pyd/std_file.so
	PYTHONPATH=$(shell pwd)/std_file/lib/pyd PYD=1 pytest -s -vv $<

std_file/lib/pyd/std_file.so: std_file/lib/pyd/libstd_file.so
	@cp $^ $@

.PHONY: std_file/lib/pyd/libstd_file.so
std_file/lib/pyd/libstd_file.so:
	@cd std_file && dub build -q -c $(DUB_CONFIGURATION)

std_file/dub.selections.json:
	@cd std_file && dub upgrade -q

.PHONY: test_std_file_pynih
test_std_file_pynih: tests/test_std_file.py std_file/lib/pynih/std_file.so
	PYTHONPATH=$(shell pwd)/std_file/lib/pynih PYNIH=1 pytest -s -vv $<

std_file/lib/pynih/std_file.so: std_file/lib/pynih/libstd_file.so
	@cp $^ $@

.PHONY: std_file/lib/pynih/libstd_file.so
std_file/lib/pynih/libstd_file.so: ../../pynih/source/python/raw.d
	@cd std_file && dub build -q -c pynih
#end std_file
