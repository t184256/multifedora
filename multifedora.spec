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
mkdir -p %{buildroot}%{_libexecdir}/multifedora \
  %{buildroot}%{_unitdir} %{buildroot}%{_sbindir}
for f in %{srcdir}/*; do
  [[ $f == *.service ]] && continue
  install -m755 "$f" %{buildroot}%{_libexecdir}/multifedora/
done
install -m644 %{srcdir}/multifedora-yield.service \
  %{buildroot}%{_unitdir}/multifedora-yield.service
ln -s %{_libexecdir}/multifedora/multifedora %{buildroot}%{_sbindir}/multifedora

%files
%{_libexecdir}/multifedora/*
%{_sbindir}/multifedora
%{_unitdir}/multifedora-yield.service
