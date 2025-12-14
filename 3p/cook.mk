curl = curl -fsSL
sha256sum = sha256sum
unzip = unzip -q
o = o
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
