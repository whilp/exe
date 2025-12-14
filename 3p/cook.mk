o = o
cosmos_bin = $(CURDIR)/$(o)/3p/cosmos/bin
use_cosmos_bin = $(if $(findstring 3p/cosmos,$(1)),$(2),$(if $(wildcard $(cosmos_bin)/$(2)),$(cosmos_bin)/$(2),$(2)))
curl = $(call use_cosmos_bin,$@,curl) -fsSL
sha256sum = $(call use_cosmos_bin,$@,sha256sum)
unzip = $(call use_cosmos_bin,$*,unzip) -q
tar = $(call use_cosmos_bin,$*,tar)
get_ext = $(if $(findstring .tar.gz,$(1)),.tar.gz,$(suffix $(1)))
pkg = $(subst /,.,$(patsubst %/,%,$(subst 3p/,,$(dir $@))))$(call get_ext,$(notdir $($(*)_url)))

$(o)/%: %/digest
	cd $(o)/$* && $(if $(findstring .tar.gz,$(pkg)),$(tar) -xzf,$(unzip) -o) $(subst /,.,$(patsubst %/,%,$(subst 3p/,,$*)))$(call get_ext,$(notdir $($*_url)))
	touch $@

%/digest: %/fetch
	cd $(o)/$(dir $<) && echo "$($(*)_sha256)  $(pkg)" | $(sha256sum) -c
	touch $@

%/fetch:
	mkdir -p $(o)/$(dir $@)
	$(curl) -o $(o)/$(subst /fetch,/$(pkg),$@) $($(*)_url)
	touch $@
