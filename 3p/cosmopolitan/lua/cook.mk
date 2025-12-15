cosmopolitan_lua := $(cosmopolitan_dir)/lua/lua
cosmopolitan_lua_libs := $(luaunit_libs)
cosmopolitan_lua_deps := $(cosmopolitan_src) $(cosmocc_bin) $(cosmos_bin) $(cosmopolitan_lua_libs)

$(cosmopolitan_lua): $(cosmopolitan_lua_deps)
	cd $(cosmopolitan_src) && $(make) -j8 o//third_party/lua/lua
	mkdir -p $(dir $@)
	cp $(cosmopolitan_src)/o//third_party/lua/lua $@
	$(foreach lib,$(cosmopolitan_lua_libs),cd $(lib)/.. && $(zip) -qr $@ $(notdir $(lib));)
