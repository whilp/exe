curl = curl -fsSL
sha256sum = sha256sum
o = o
pkg = $(subst /,.,$(patsubst %/,%,$(subst 3p/,,$(dir $@))))$(suffix $(notdir $($(*)_url)))

%/digest:
	mkdir -p $(o)/$(dir $@)
	$(curl) -o $(o)/$(subst /digest,/$(pkg),$@) $($(*)_url)
	cd $(o)/$(dir $@) && echo "$($(*)_sha256)  $(pkg)" | $(sha256sum) -c
