o/3p/lre: o/3p/lre/lua
	touch $@

o/3p/lre/lua: o/3p/cosmopolitan 3p/lre/lre.c
	mkdir -p o/3p/lre
	touch $@

.PHONY: o/3p/lre
