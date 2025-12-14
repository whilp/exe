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
pkg = $(subst /,.,$(patsubst %/,%,$(subst 3p/,,$(dir $@))))$(call get_ext,$(notdir $($(*)_url)))

$(o)/%: %/digest
	cd $(o)/$* && $(if $(findstring .tar.gz,$(pkg)),$(tar) -xzf,$(unzip) -q -o) $(subst /,.,$(patsubst %/,%,$(subst 3p/,,$*)))$(call get_ext,$(notdir $($*_url)))
	touch $@

%/digest: %/fetch
	cd $(o)/$(dir $<) && echo "$($(*)_sha256)  $(pkg)" | $(sha256sum) -c
	touch $@

%/fetch:
	mkdir -p $(o)/$(dir $@)
	$(curl) -fsSL -o $(o)/$(subst /fetch,/$(pkg),$@) $($(*)_url)
	touch $@
