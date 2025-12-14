curl = curl -fsSL
sha256sum = sha256sum

%/digest:
	$(curl) -o $(subst /digest,/$(notdir $($(*)_url)),$@) $($(*)_url)
	cd $(dir $@) && $(sha256sum) -c $(notdir $($(*)_url)).sha256
