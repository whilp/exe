o/3p/lua/lua: o/3p/cosmopolitan 3p/lua/linit.c.patch 3p/lua/BUILD.mk.patch
	mkdir -p o/3p/lua
	cd $(cosmopolitan_src)/third_party/lua && patch -p0 -N < $(CURDIR)/3p/lua/linit.c.patch || true
	cp $(cosmopolitan_src)/tool/net/lre.c $(cosmopolitan_src)/third_party/lua/lre.c
	cp $(cosmopolitan_src)/tool/net/lpath.c $(cosmopolitan_src)/third_party/lua/lpath.c
	cp 3p/lua/BUILD.mk.patch $(cosmopolitan_src)/third_party/lua/BUILD.mk
	cd $(cosmopolitan_src) && rm -f o//third_party/lua/lua.a.pkg o//third_party/lua/lua.pkg o//third_party/lua/lua
	cd $(cosmopolitan_src) && $(make) -j8 o//third_party/lua/lua
	cp $(cosmopolitan_src)/o//third_party/lua/lua o/3p/lua/lua

o/3p/lua: o/3p/lua/lua o/3p/cosmopolitan/luac o/3p/cosmopolitan/lunix.a o/3p/luaunit
	mkdir -p o/3p/lua/bin o/3p/lua/lib o/3p/lua/.lua
	cp o/3p/lua/lua o/3p/lua/bin/
	cp o/3p/cosmopolitan/third_party/lua/luac o/3p/lua/bin/
	cp o/3p/cosmopolitan/lunix.a o/3p/lua/lib/
	cp o/3p/luaunit/luaunit.lua o/3p/lua/.lua/
	cd o/3p/lua && zip -q bin/lua .lua/luaunit.lua
	touch $@

3p/lua/test: o/3p/lua
	$(lua) 3p/lua/test_unix.lua
	$(lua) 3p/lua/test_modules.lua
	$(lua) 3p/lua/test_re.lua
	$(lua) 3p/lua/test_path.lua

.PHONY: 3p/lua/test
