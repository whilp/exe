include 3p/cook.mk
include 3p/luaunit/cook.mk
include 3p/cosmopolitan/cook.mk
include 3p/lua/cook.mk

build: lua
test: lua
	$(lua_bin) 3p/lua/test.lua

clean:
	rm -rf o results

.PHONY: build test clean
