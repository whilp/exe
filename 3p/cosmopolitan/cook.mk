3p/cosmopolitan_url = https://github.com/jart/cosmopolitan/releases/download/4.0.2/cosmopolitan-4.0.2.tar.gz
3p/cosmopolitan_sha256 = e466106b18064e0c996ef64d261133af867bccd921ad14e54975d89aa17a8717
cosmopolitan_dir := $(3p)/cosmopolitan
cosmopolitan_tarball := $(cosmopolitan_dir)/cosmopolitan.tar.gz
cosmopolitan_src := $(cosmopolitan_dir)/cosmopolitan-4.0.2

$(cosmopolitan_src): $(cosmopolitan_tarball)
	cd $(cosmopolitan_dir) && $(tar) -xzf $(notdir $<)

$(cosmopolitan_tarball): $(cosmopolitan_dir)
	$(curl) -o $@ $(3p/cosmopolitan_url)
	cd $(dir $@) && echo "$(3p/cosmopolitan_sha256)  $(notdir $@)" | $(sha256sum) -c

$(cosmopolitan_dir):
	mkdir -p $@

cosmopolitan_lua := $(cosmopolitan_dir)/lua
cosmopolitan_lua_libs := $(luaunit_file)
cosmopolitan_lua_libs_zip := $(cosmopolitan_dir)/lua_libs.zip
cosmopolitan_lua_staging := $(cosmopolitan_dir)/.lua

$(cosmopolitan_lua_libs_zip): $(cosmopolitan_lua_libs)
	mkdir -p $(cosmopolitan_lua_staging)
	$(foreach lib,$(cosmopolitan_lua_libs),cp $(lib) $(cosmopolitan_lua_staging)/$(notdir $(lib));)
	cd $(cosmopolitan_dir) && $(zip) -r $(notdir $@) .lua
	rm -rf $(cosmopolitan_lua_staging)

$(cosmopolitan_lua): $(cosmopolitan_src) $(cosmocc_bin) $(cosmos_bin) $(cosmopolitan_lua_libs_zip)
	cd $(cosmopolitan_src) && $(make) -j8 o//third_party/lua/lua
	mkdir -p $(dir $@)
	cp $(cosmopolitan_src)/o//third_party/lua/lua $@
	cd $(cosmopolitan_dir) && $(zip) -rm $(cosmopolitan_lua) $(notdir $(cosmopolitan_lua_libs_zip))
