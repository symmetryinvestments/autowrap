DC ?= dmd
export PYTHON_LIB_DIR ?= /usr/lib
export DUB_CONFIGURATION ?= env
export PYD_LIBPYTHON_DIR ?= /usr/lib
export PYD_LIBPYTHON ?= python3.9
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
	@cd std_$1 && dub build -q -c $(DUB_CONFIGURATION) --compiler=${DC}

std_$1/dub.selections.json:
	@cd std_$1 && dub upgrade -q

.PHONY: test_std_$1_pynih
test_std_$1_pynih: tests/test_std_$1.py std_$1/lib/pynih/std_$1.so
	PYTHONPATH=$(shell pwd)/std_$1/lib/pynih PYNIH=1 pytest -s -vv $$<

std_$1/lib/pynih/std_$1.so: std_$1/lib/pynih/libstd_$1.so
	@cp $$^ $$@

.PHONY: std_$1/lib/pynih/libstd_$1.so
std_$1/lib/pynih/libstd_$1.so:
	@cd std_$1 && dub build -q -c pynih --compiler=${DC}
endef


.PHONY: all
all: test_std_algorithm test_std_array test_std_ascii   \
test_std_base64 test_std_bigint test_std_compiler test_std_complex \
test_std_container test_std_conv test_std_csv test_std_datetime \
test_std_demangle test_std_encoding test_std_exception \
test_std_experimental test_std_file test_std_format \
test_std_functional test_std_getopt test_std_json test_std_math \
test_std_mathspecial test_std_meta test_std_mmfile test_std_net \
test_std_numeric test_std_outbuffer test_std_path test_std_process \
test_std_random test_std_range test_std_regex test_std_signals \
test_std_socket test_std_stdint test_std_stdio test_std_string test_std_system \
test_std_traits test_std_typecons test_std_typetuple test_std_uri \
test_std_utf test_std_uuid test_std_variant test_std_windows \
test_std_zip test_std_zlib
# test_std_uni disabled for now due to dmd bug causing it to crash

$(eval $(call test-package,algorithm))
$(eval $(call test-package,array))
$(eval $(call test-package,ascii))
$(eval $(call test-package,base64))
$(eval $(call test-package,bigint))
$(eval $(call test-package,compiler))
$(eval $(call test-package,complex))
$(eval $(call test-package,container))
$(eval $(call test-package,conv))
$(eval $(call test-package,csv))
# $(eval $(call test-package,datetime))
.PHONY: test_std_datetime
test_std_datetime:
	echo "FIXME"
$(eval $(call test-package,demangle))
$(eval $(call test-package,digest))
$(eval $(call test-package,encoding))
$(eval $(call test-package,exception))
#$(eval $(call test-package,experimental))
.PHONY: test_std_experimental
test_std_experimental:
	echo "FIXME"

#$(eval $(call test-package,file))
.PHONY: test_std_file
test_std_file:
	echo "FIXME"

$(eval $(call test-package,format))
$(eval $(call test-package,functional))
$(eval $(call test-package,getopt))
$(eval $(call test-package,json))
$(eval $(call test-package,math))
$(eval $(call test-package,mathspecial))
$(eval $(call test-package,meta))
$(eval $(call test-package,mmfile))
#$(eval $(call test-package,net))
.PHONY: test_std_net
test_std_net:
	echo "FIXME"
$(eval $(call test-package,numeric))
$(eval $(call test-package,outbuffer))
$(eval $(call test-package,path))
$(eval $(call test-package,process))
$(eval $(call test-package,random))
$(eval $(call test-package,range))
$(eval $(call test-package,regex))
$(eval $(call test-package,signals))
$(eval $(call test-package,socket))
$(eval $(call test-package,stdint))
$(eval $(call test-package,stdio))
$(eval $(call test-package,string))
$(eval $(call test-package,system))
$(eval $(call test-package,traits))
$(eval $(call test-package,typecons))
$(eval $(call test-package,typetuple))
$(eval $(call test-package,uni))
$(eval $(call test-package,uri))
$(eval $(call test-package,utf))
$(eval $(call test-package,uuid))
$(eval $(call test-package,variant))
$(eval $(call test-package,windows))
#$(eval $(call test-package,zip))
.PHONY: test_std_zip
test_std_zip:
	echo "README"
$(eval $(call test-package,zlib))
