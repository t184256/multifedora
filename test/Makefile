# aliases
EXTRACTED = tmp/03/second.esp.tar tmp/03/second.boot.tar \
            tmp/03/second.rootfs tmp/03/second.rootfs.manifest
.DEFAULT_GOAL := extract-second
.PHONY: install-initial install-second extract-second inject
install-initial: tmp/01/initial.img
install-second: tmp/02/second.img
extract-second: $(EXTRACTED)
inject: tmp/04/injected.img

ISO_URL ?= https://download.fedoraproject.org/pub/fedora/linux/releases/44/$\
    Server/x86_64/iso/Fedora-Server-dvd-x86_64-44-1.7.iso
LUKS_PASS ?= example

tmp/fedora.iso:
	@mkdir -p tmp
	wget $(ISO_URL) -O $@

tmp/01/initial.img: tmp/fedora.iso 01-install-initial tool-install
	./01-install-initial

tmp/02/second.img: tmp/01/initial.img tmp/fedora.iso
tmp/02/second.img: 02-install-second tool-install
	./02-install-second

$(EXTRACTED) &: tmp/02/second.img 03-extract-second ../multifedora-extract
	./03-extract-second

tmp/04/injected.img: tmp/02/second.img $(EXTRACTED) 04-inject
tmp/04/injected.img: ../multifedora-inject
	./04-inject

.PHONY: clean deepclean
clean:
	rm -rf tmp/01 tmp/02 tmp/03 tmp/04

deepclean: clean
	rm -rf tmp
