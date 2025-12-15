o := o
cosmos_bin := $(CURDIR)/$(o)/3p/cosmos/bin
cosmocc_dir := $(CURDIR)/$(o)/3p/cosmocc
lua_bin := $(CURDIR)/$(o)/3p/lua/bin

export PATH := $(lua_bin):$(cosmos_bin):$(PATH)
export COSMOCC := $(cosmocc_dir)

curl := curl
sha256sum := sha256sum
unzip := unzip
tar := tar
make := make
lua := lua

get_ext = $(if $(findstring .tar.gz,$(1)),.tar.gz,$(suffix $(1)))

$(o)/3p/%: $(o)/3p/.%/digest
	mkdir -p $(o)/3p/$*
	cd $(o)/3p/$* && $(if $(findstring .tar.gz,$(notdir $(3p/$*_url))),$(tar) -xzf,$(unzip) -q -o) ../.$*/$(notdir $(3p/$*_url))
	touch $@

$(o)/3p/.%/digest: $(o)/3p/.%/fetch
	cd $(o)/3p/.$* && echo "$(3p/$*_sha256)  $(notdir $(3p/$*_url))" | $(sha256sum) -c
	touch $@

$(o)/3p/.%/fetch:
	mkdir -p $(o)/3p/.$*
	$(curl) -fsSL -o $(o)/3p/.$*/$(notdir $(3p/$*_url)) $(3p/$*_url)
	touch $@
