3p/cosmopolitan_url = https://github.com/jart/cosmopolitan/releases/download/4.0.2/cosmopolitan-4.0.2.tar.gz
3p/cosmopolitan_sha256 = e466106b18064e0c996ef64d261133af867bccd921ad14e54975d89aa17a8717
cosmopolitan_src := $(o)/3p/cosmopolitan/cosmopolitan-4.0.2

o/3p/cosmopolitan/%: o/3p/cosmopolitan o/3p/cosmocc o/3p/cosmos
	cd $(cosmopolitan_src) && $(make) -j8 o//$(*)
	mkdir -p $(dir $@)
	cp $(cosmopolitan_src)/o//$(*) $@

o/3p/cosmopolitan/lua: o/3p/cosmopolitan/third_party/lua/lua
	cp o/3p/cosmopolitan/third_party/lua/lua o/3p/cosmopolitan/lua

o/3p/cosmopolitan/luac: o/3p/cosmopolitan/third_party/lua/luac
	cp o/3p/cosmopolitan/third_party/lua/luac o/3p/cosmopolitan/luac

o/3p/cosmopolitan/lunix.a: o/3p/cosmopolitan/third_party/lua/lunix.a
	cp o/3p/cosmopolitan/third_party/lua/lunix.a o/3p/cosmopolitan/lunix.a
