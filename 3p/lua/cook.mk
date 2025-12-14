o/3p/lua: o/3p/lre o/3p/cosmopolitan/luac o/3p/cosmopolitan/lunix.a o/3p/luaunit
	mkdir -p o/3p/lua/bin o/3p/lua/lib o/3p/lua/.lua
	cp o/3p/lre/lua o/3p/lua/bin/
	cp o/3p/cosmopolitan/third_party/lua/luac o/3p/lua/bin/
	cp o/3p/cosmopolitan/lunix.a o/3p/lua/lib/
	cp o/3p/luaunit/luaunit.lua o/3p/lua/.lua/
	cd o/3p/lua && zip -q bin/lua .lua/luaunit.lua
	touch $@

3p/lua/test: o/3p/lua
	$(lua) 3p/lua/test_unix.lua
	$(lua) 3p/lua/test_modules.lua
	$(lua) 3p/lua/test_re.lua

.PHONY: 3p/lua/test
