o := $(CURDIR)/o
3p := $(o)/3p

curl := curl -fsSL
sha256sum := sha256sum
unzip := unzip -q -DD
zip := zip -q
tar := tar -m
lua := lua

include 3p/cosmocc/cook.mk
include 3p/cosmos/cook.mk
include 3p/luaunit/cook.mk
include 3p/cosmopolitan/cook.mk
include 3p/lua/cook.mk

export PATH := $(dir $(cosmos_bin)):$(dir $(cosmocc_bin)):$(PATH)
export CC := $(cosmocc_bin)
export AR := $(dir $(cosmocc_bin))cosmocc-ar
export RANLIB := $(dir $(cosmocc_bin))cosmocc-ranlib

make := make COSMOCC=$(cosmocc_dir)

build: lua
test: lua
	$(lua_bin) 3p/lua/test.lua

clean:
	rm -rf o results

.PHONY: build test clean
