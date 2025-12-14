curl = curl -fsSL
sha256sum = sha256sum
o = o
sha256_path = $(CURDIR)/$(dir $@)$(notdir $($(*)_url)).sha256

%/digest:
	mkdir -p $(o)/$(dir $@)
	$(curl) -o $(o)/$(subst /digest,/$(notdir $($(*)_url)),$@) $($(*)_url)
	cd $(o)/$(dir $@) && $(sha256sum) -c $(sha256_path)
