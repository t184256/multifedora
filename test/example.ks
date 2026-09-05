cdrom  # required: install
cmdline  # required: text mode
autopart --encrypted --passphrase=example --type=btrfs  # required: storage
network --hostname=example  # -net none, hostname only
rootpw example

%packages --exclude-weakdeps
@core --nodefaults
openssh-server
-audit  # not -audit*: audit-libs is required by util-linux/openssh/shadow-utils
-chrony
-dracut-config-rescue
-firewalld
-fwupd
-glibc-gconv-extra.x86_64
-iproute
-iputils
-kernel
-kernel-modules
-langpacks-en
-libbpf
-libmnl
-lvm2
-man-db
-ncurses
-plymouth*
-prefixdevname
-sssd-*
-vim-minimal
glibc-minimal-langpack
kernel-core
kernel-modules-core
%end

poweroff
