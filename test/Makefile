# aliases
EXTRACTED = tmp/03/second.esp.tar tmp/03/second.boot.tar \
            tmp/03/second.rootfs tmp/03/second.rootfs.manifest
VM_TOOLS = tool-spin-up tool-inside-vm
.DEFAULT_GOAL := all
.PHONY: all install-initial install-second extract-second inject-remove \
        dual-install dual-boot-primary dual-boot-secondary \
        yield yield-again chroot
all: inject-remove dual-install dual-boot-primary dual-boot-secondary \
     yield yield-again chroot
install-initial: tmp/01/initial.img
install-second: tmp/02/second.img
extract-second: $(EXTRACTED)
inject-remove: tmp/04/ok
dual-install: tmp/05/dual.img
dual-boot-primary: tmp/06/ok
dual-boot-secondary: tmp/07/ok
yield: tmp/08/yielded.img
yield-again: tmp/09/ok
chroot: tmp/10/ok

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
tmp/02/second.img: $(VM_TOOLS)
	./02-install-second

# grouped targets cannot take prerequisite-only lines, hence one line
$(EXTRACTED) &: tmp/02/second.img 03-extract-second ../multifedora-extract $(VM_TOOLS)
	./03-extract-second

tmp/04/ok: tmp/02/second.img $(EXTRACTED) 04-inject-remove
tmp/04/ok: ../multifedora-inject ../multifedora-remove
tmp/04/ok: ../multifedora-esp-menu
tmp/04/ok: $(VM_TOOLS)
	./04-inject-remove

# renamed from tmp.img on completion, so the target exists only on
# success (a failed run leaves tmp.img behind and make re-runs)
tmp/05/dual.img: tmp/01/initial.img $(EXTRACTED) 05-dual-install
tmp/05/dual.img: ../multifedora-new-secondary ../multifedora-inject
tmp/05/dual.img: ../multifedora-list
tmp/05/dual.img: ../multifedora-reseat ../multifedora-esp-menu
tmp/05/dual.img: $(VM_TOOLS)
	./05-dual-install

tmp/06/ok: tmp/05/dual.img 06-dual-boot-primary
tmp/06/ok: $(VM_TOOLS)
	./06-dual-boot-primary

tmp/07/ok: tmp/05/dual.img 07-dual-boot-secondary
tmp/07/ok: $(VM_TOOLS)
	./07-dual-boot-secondary

tmp/08/yielded.img: tmp/01/initial.img $(EXTRACTED) 08-yield
tmp/08/yielded.img: ../multifedora-prime-yield ../multifedora-inject
tmp/08/yielded.img: ../multifedora-list
tmp/08/yielded.img: ../multifedora-reseat ../multifedora-esp-menu
tmp/08/yielded.img: ../multifedora-yield ../multifedora-yield.service
tmp/08/yielded.img: $(VM_TOOLS)
	./08-yield

tmp/09/ok: tmp/08/yielded.img 09-yield-again
tmp/09/ok: ../multifedora-prime-yield ../multifedora-inject
tmp/09/ok: ../multifedora-list
tmp/09/ok: ../multifedora-reseat ../multifedora-esp-menu
tmp/09/ok: ../multifedora-yield ../multifedora-yield.service
tmp/09/ok: $(EXTRACTED) $(VM_TOOLS)
	./09-yield-again

tmp/10/ok: tmp/05/dual.img tmp/02/second.img 10-chroot
tmp/10/ok: ../multifedora ../multifedora-list ../multifedora-chroot
tmp/10/ok: ../multifedora-chroot-image ../multifedora-chroot-secondary
tmp/10/ok: $(VM_TOOLS)
	./10-chroot

.PHONY: clean deepclean
clean:
	rm -rf tmp/01 tmp/02 tmp/03 tmp/04 tmp/05 tmp/06 tmp/07 tmp/08 tmp/09 \
	       tmp/10

deepclean: clean
	rm -rf tmp
