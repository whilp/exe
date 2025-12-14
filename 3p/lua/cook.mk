o/3p/lua: o/3p/cosmopolitan/lua o/3p/cosmopolitan/luac o/3p/cosmopolitan/lunix.a
	mkdir -p o/3p/lua/bin o/3p/lua/lib
	cp o/3p/cosmopolitan/third_party/lua/lua o/3p/lua/bin/
	cp o/3p/cosmopolitan/third_party/lua/luac o/3p/lua/bin/
	cp o/3p/cosmopolitan/lunix.a o/3p/lua/lib/
	touch $@
