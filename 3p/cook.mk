o = o
cosmos_bin = $(CURDIR)/$(o)/3p/cosmos/bin
pkg = $(subst /,.,$(patsubst %/,%,$(subst 3p/,,$(dir $@))))$(suffix $(notdir $($(*)_url)))

$(o)/%: %/digest
	cd $(o)/$* && $(if $(findstring 3p/cosmos,$*),unzip,$(if $(wildcard $(cosmos_bin)/unzip),$(cosmos_bin)/unzip,unzip)) -q -o $(subst /,.,$(patsubst %/,%,$(subst 3p/,,$*)))$(suffix $(notdir $($*_url)))
	touch $@

%/digest: %/fetch
	cd $(o)/$(dir $<) && echo "$($(*)_sha256)  $(pkg)" | $(if $(findstring 3p/cosmos,$@),sha256sum,$(if $(wildcard $(cosmos_bin)/sha256sum),$(cosmos_bin)/sha256sum,sha256sum)) -c
	touch $@

%/fetch:
	mkdir -p $(o)/$(dir $@)
	$(if $(findstring 3p/cosmos,$@),curl,$(if $(wildcard $(cosmos_bin)/curl),$(cosmos_bin)/curl,curl)) -fsSL -o $(o)/$(subst /fetch,/$(pkg),$@) $($(*)_url)
	touch $@
