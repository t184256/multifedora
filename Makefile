# This is for running the examples, basically

ISO_URL ?= https://dl.fedoraproject.org/pub/fedora/linux/releases/44/$\
    Server/x86_64/iso/Fedora-Server-dvd-x86_64-44-1.7.iso
LUKS_PASS ?= example

example.img: fedora.iso example.ks.img
	./example-fedora-install $^ $@

fedora.iso:
	wget $(ISO_URL) -O fedora.iso

example.ks.img: example.ks
	./fedora-make-kickstart-image $< $@

EXTD = example-fedora-ESP.tar example-fedora-boot.tar example-fedora-root.btrfs
$(EXTD) &: example.img
	./fedora-extract $^ $(LUKS_PASS) $(EXTD)

.PHONY: clean deepclean
clean:
	rm -f example.ks.img example.img $(EXTD)

deepclean: clean
	rm -f fedora.iso
