o/3p/lua: o/3p/cosmopolitan o/3p/cosmocc o/3p/cosmos
	cd o/3p/cosmopolitan/cosmopolitan-4.0.2 && $(make) -j8 o//third_party/lua/lua o//third_party/lua/luac
	mkdir -p o/3p/lua/bin
	cp o/3p/cosmopolitan/cosmopolitan-4.0.2/o//third_party/lua/lua o/3p/lua/bin/
	cp o/3p/cosmopolitan/cosmopolitan-4.0.2/o//third_party/lua/luac o/3p/lua/bin/
	touch $@
