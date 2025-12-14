o = o
cosmos_bin = $(CURDIR)/$(o)/3p/cosmos/bin
use_cosmos_bin = $(if $(findstring 3p/cosmos,$(1)),$(2),$(if $(wildcard $(cosmos_bin)/$(2)),$(cosmos_bin)/$(2),$(2)))
curl = $(call use_cosmos_bin,$@,curl) -fsSL
sha256sum = $(call use_cosmos_bin,$@,sha256sum)
unzip = $(call use_cosmos_bin,$*,unzip) -q
pkg = $(subst /,.,$(patsubst %/,%,$(subst 3p/,,$(dir $@))))$(suffix $(notdir $($(*)_url)))

$(o)/%: %/digest
	cd $(o)/$* && $(unzip) -o $(subst /,.,$(patsubst %/,%,$(subst 3p/,,$*)))$(suffix $(notdir $($*_url)))
	touch $@

%/digest: %/fetch
	cd $(o)/$(dir $<) && echo "$($(*)_sha256)  $(pkg)" | $(sha256sum) -c
	touch $@

%/fetch:
	mkdir -p $(o)/$(dir $@)
	$(curl) -o $(o)/$(subst /fetch,/$(pkg),$@) $($(*)_url)
	touch $@
