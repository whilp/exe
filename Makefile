include 3p/cook.mk
include 3p/cosmocc/cook.mk
include 3p/cosmos/cook.mk
include 3p/cosmopolitan/cook.mk
include 3p/lua/cook.mk

test: o/3p/lua
	3p/cosmocc/test
	3p/cosmos/test
	3p/cosmopolitan/test
	3p/lua/test

.PHONY: test
