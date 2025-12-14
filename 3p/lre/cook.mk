o/3p/lre: o/3p/lre/lua
	touch $@

o/3p/lre/lua: o/3p/cosmopolitan 3p/lre/linit.c 3p/lre/lre.c
	mkdir -p o/3p/lre
	cp 3p/lre/linit.c $(cosmopolitan_src)/third_party/lua/linit.c
	cp 3p/lre/lre.c $(cosmopolitan_src)/third_party/lua/lre.c
	cd $(cosmopolitan_src) && rm -f o//third_party/lua/lua.a.pkg o//third_party/lua/lua.pkg o//third_party/lua/lua
	cd $(cosmopolitan_src) && $(make) -j8 o//third_party/lua/lua
	cp $(cosmopolitan_src)/o//third_party/lua/lua o/3p/lre/lua

.PHONY: o/3p/lre
