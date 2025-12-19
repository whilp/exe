include 3p/cook.mk
include 3p/luaunit/cook.mk
include 3p/cosmopolitan/cook.mk
include 3p/cosmopolitan/lua/cook.mk

build-x86_64: lua-x86_64
build-aarch64: lua-aarch64
fatten: lua-fatten
test: lua-test

clean:
	rm -rf o cosmos results

.PHONY: build-x86_64 build-aarch64 fatten test clean
