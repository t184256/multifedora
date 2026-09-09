Name:		multifedora
Version:	{{ver}}
Release:	{{rel}}%{?dist}
Summary:	Manage multiple Fedora systems on one disk
License:	MIT
URL:		https://github.com/t184256/multifedora
Source0:	https://github.com/t184256/multifedora/archive/{{git_commit}}/{{tarball}}

BuildRequires:	systemd-rpm-macros

BuildArch:	noarch
AutoReqProv:	no
Requires:	/bin/bash
Requires:	multifedora-lib = %{version}-%{release}
Recommends:	multifedora-chroot

%description
Install additional Fedora systems on your existing btrfs rootfs
and select which one to boot in the ESP GRUB menu.

The entry point is the multifedora command; the tools it drives
live in the multifedora-lib subpackage.

%package lib
Summary:	Tools that manage multiple Fedora systems on one disk
Requires:	btrfs-progs
Requires:	cryptsetup
Requires:	dracut
Requires:	grep
Requires:	sed
Requires:	systemd
Requires:	tar
Requires:	util-linux

%description lib
The multifedora tools proper, installed in /usr/libexec/multifedora.

%package chroot
Summary:	Run commands in installed systems and disk images
# the tools are self-contained, so -lib is not required; but if both
# are present they must come from the same build
Conflicts:	multifedora-lib < %{version}-%{release}
Conflicts:	multifedora-lib > %{version}-%{release}
Requires:	systemd-container

%description chroot
The multifedora chroot commands, running systemd-nspawn on a
secondary system or on a raw Fedora disk image.

%prep
%setup -q -n multifedora-{{git_commit}}

%build
# noop

%install
mkdir -p %{buildroot}%{_libexecdir}/multifedora \
  %{buildroot}%{_unitdir} %{buildroot}%{_sbindir}
install -m755 multifedora %{buildroot}%{_libexecdir}/multifedora/
for f in multifedora-*; do
  [[ $f == *.service ]] && continue
  install -m755 "$f" %{buildroot}%{_libexecdir}/multifedora/
done
# the sources keep #!/usr/bin/env bash for portability (NixOS);
# Fedora policy wants an absolute interpreter in packaged scripts
for f in %{buildroot}%{_libexecdir}/multifedora/*; do
  [[ $f == *.service ]] && continue
  sed -i '1s|^#!/usr/bin/env bash$|#!/bin/bash|' "$f"
done
install -m644 multifedora-yield.service \
  %{buildroot}%{_unitdir}/multifedora-yield.service
ln -s %{_libexecdir}/multifedora/multifedora %{buildroot}%{_sbindir}/multifedora

%files
%license LICENSE
%{_sbindir}/multifedora
%{_libexecdir}/multifedora/multifedora

%files lib
%{_unitdir}/multifedora-yield.service
%exclude %{_libexecdir}/multifedora/multifedora
%exclude %{_libexecdir}/multifedora/multifedora-chroot
%exclude %{_libexecdir}/multifedora/multifedora-chroot-image
%exclude %{_libexecdir}/multifedora/multifedora-chroot-secondary
%exclude %{_libexecdir}/multifedora/multifedora-chroot-next
%{_libexecdir}/multifedora/*

%files chroot
%{_libexecdir}/multifedora/multifedora-chroot
%{_libexecdir}/multifedora/multifedora-chroot-image
%{_libexecdir}/multifedora/multifedora-chroot-secondary
%{_libexecdir}/multifedora/multifedora-chroot-next

# templated from build.sh
%changelog
