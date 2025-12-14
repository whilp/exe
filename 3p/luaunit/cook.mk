luaunit_url = https://raw.githubusercontent.com/bluebird75/luaunit/LUAUNIT_V3_4/luaunit.lua
luaunit_sha256 = bf3e3fb25b77739fa1ebc324582776d26486e32e49c150628bc21b9b9e6ce645

o/3p/luaunit/luaunit.lua:
	mkdir -p o/3p/luaunit
	$(curl) -fsSL -o $@ $(luaunit_url)
	cd o/3p/luaunit && echo "$(luaunit_sha256)  luaunit.lua" | $(sha256sum) -c

o/3p/luaunit: o/3p/luaunit/luaunit.lua
	touch $@
