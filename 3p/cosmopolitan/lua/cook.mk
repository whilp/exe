cosmopolitan_lua := $(cosmopolitan_dir)/lua/lua
cosmopolitan_lua_lib_dir := $(luaunit_libs)
cosmopolitan_lua_patch_dir := 3p/cosmopolitan/lua
cosmopolitan_lua_patched := $(cosmopolitan_dir)/.lua_patched
cosmopolitan_lua_deps := $(cosmopolitan_src) $(cosmocc_bin) $(cosmos_bin) $(cosmopolitan_lua_lib_dir)/luaunit.lua $(cosmopolitan_lua_patched)
cosmopolitan_lua_tests := 3p/cosmopolitan/lua

$(cosmopolitan_lua_patched): $(cosmopolitan_src)
	cp $(dir $(cosmopolitan_src))/tool/net/lpath.c $(dir $(cosmopolitan_src))/third_party/lua/
	cp $(dir $(cosmopolitan_src))/tool/net/lpath.h $(dir $(cosmopolitan_src))/third_party/lua/
	cp $(dir $(cosmopolitan_src))/tool/net/lre.c $(dir $(cosmopolitan_src))/third_party/lua/
	cp $(CURDIR)/$(cosmopolitan_lua_patch_dir)/lre.h $(dir $(cosmopolitan_src))/third_party/lua/
	cp $(dir $(cosmopolitan_src))/tool/net/lsqlite3.c $(dir $(cosmopolitan_src))/third_party/lua/
	cp $(CURDIR)/$(cosmopolitan_lua_patch_dir)/lsqlite3.h $(dir $(cosmopolitan_src))/third_party/lua/
	cp $(dir $(cosmopolitan_src))/tool/net/largon2.c $(dir $(cosmopolitan_src))/third_party/lua/
	cp $(CURDIR)/$(cosmopolitan_lua_patch_dir)/largon2.h $(dir $(cosmopolitan_src))/third_party/lua/
	cd $(dir $(cosmopolitan_src)) && patch -p1 < $(CURDIR)/$(cosmopolitan_lua_patch_dir)/BUILD.mk.patch
	cd $(dir $(cosmopolitan_src)) && patch -p1 < $(CURDIR)/$(cosmopolitan_lua_patch_dir)/lua.main.c.patch
	touch $@

$(cosmopolitan_lua): $(cosmopolitan_lua_deps)
	cd $(dir $(cosmopolitan_src)) && $(make) -j8 o//third_party/lua/lua
	mkdir -p $(dir $@)
	cp $(dir $(cosmopolitan_src))/o//third_party/lua/lua $@
	cd $(cosmopolitan_lua_lib_dir)/.. && $(zip) -qr $@ $(notdir $(cosmopolitan_lua_lib_dir))

.PHONY: test-cosmopolitan-lua
test-cosmopolitan-lua: $(cosmopolitan_lua)
	$(cosmopolitan_lua) $(cosmopolitan_lua_tests)/test.lua
