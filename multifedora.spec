Name:           multifedora
Version:        0.1
Release:        1%{?dist}
Summary:        Manage multiple Fedora systems on one disk
License:        MIT
BuildArch:      noarch
AutoReqProv:    no
Requires:       btrfs-progs
Requires:       cryptsetup
Requires:       dracut
Requires:       grep
Requires:       sed
Requires:       systemd
Requires:       tar
Requires:       util-linux

%description
Install additional Fedora systems on your existing btrfs rootfs
and select which one to boot in the ESP GRUB menu.

%install
mkdir -p %{buildroot}%{_libexecdir}/multifedora %{buildroot}%{_sbindir}
for f in %{srcdir}/*; do
  install -m755 "$f" %{buildroot}%{_libexecdir}/multifedora/
done
ln -s %{_libexecdir}/multifedora/multifedora %{buildroot}%{_sbindir}/multifedora

%files
%{_libexecdir}/multifedora/*
%{_sbindir}/multifedora
