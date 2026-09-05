# This is for running the examples, basically

ISO_URL ?= https://download.fedoraproject.org/pub/fedora/linux/releases/44/$\
    Server/x86_64/iso/Fedora-Server-dvd-x86_64-44-1.7.iso
LUKS_PASS ?= example

tmp/example.img: tmp/fedora.iso
	@mkdir -p tmp
	./tool-install $< $@

tmp/fedora.iso:
	@mkdir -p tmp
	wget $(ISO_URL) -O $@

EXTD = tmp/example.esp.tar tmp/example.boot.tar tmp/example.subvolumes.btrfs
$(EXTD) &: tmp/example.img
	./extract

# short aliases
.PHONY: example.img ext
example.img: tmp/example.img
ext: $(EXTD)

.PHONY: clean deepclean
clean:
	rm -f tmp/example.ks.img tmp/example.img tmp/inception.tmp.img $(EXTD)
	rm -rf tmp/extract-share

deepclean: clean
	rm -f tmp/fedora.iso
