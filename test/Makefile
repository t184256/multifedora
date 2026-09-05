# This is for running the examples, basically

ISO_URL ?= https://download.fedoraproject.org/pub/fedora/linux/releases/44/$\
    Server/x86_64/iso/Fedora-Server-dvd-x86_64-44-1.7.iso
LUKS_PASS ?= example

tmp/example.img: tmp/fedora.iso tmp/example.ks.img
	@mkdir -p tmp
	./tool-install $^ $@

tmp/fedora.iso:
	@mkdir -p tmp
	wget $(ISO_URL) -O $@

tmp/example.ks.img: example.ks
	@mkdir -p tmp
	./tool-ks-image $< $@

EXTD = tmp/example-fedora-ESP.tar tmp/example-fedora-boot.tar tmp/example-fedora-root.btrfs
$(EXTD) &: tmp/example.img
	../fedora-extract $^ $(LUKS_PASS) $(EXTD)

# short aliases
.PHONY: example.img ext
example.img: tmp/example.img
ext: $(EXTD)

.PHONY: clean deepclean
clean:
	rm -f tmp/example.ks.img tmp/example.img $(EXTD)

deepclean: clean
	rm -f tmp/fedora.iso
