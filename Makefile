include 3p/cook.mk
include 3p/cosmopolitan/cook.mk
include 3p/luaunit/cook.mk

#test: o/3p/lua
#	3p/cosmocc/test
#	3p/cosmos/test
#	3p/cosmopolitan/test
#	3p/cosmopolitan/lua/test

clean:
	rm -rf o

.PHONY: test clean
