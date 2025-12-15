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

$(cosmopolitan_lua): $(cosmopolitan_src) $(cosmocc_bin) $(cosmos_bin)
	cd $(cosmopolitan_src) && $(make) -j8 o//third_party/lua/lua
	mkdir -p $(dir $@)
	cp $(cosmopolitan_src)/o//third_party/lua/lua $@
