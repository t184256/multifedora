# multifedora

## What?

Ever wanted to put a second Fedora onto the existing disk? \
Reinstall your setup fresh in the background? \
Promote a VM into your main system? \
No? \
Anyone? \
...? \
Anyway, now you can.

```
sudo multifedora prime-pivot crufty new-image.raw
sudo reboot
# choose between [primary] (your new system) and crufty (your previous one)
sudo multifedora add test test-image.raw
sudo multifedora remove crufty
sudo reboot
# and now the choice is between the same [primary] and test
```

## Why?

I actually have a proprietary and shameful use case for it I won't disclose,
but since most of the heavy lifting behind it is open-sourceable,
I'm sharing this in hopes that it'll inspire more madness in somebody else.

## How?

Rather uncreatively: ESP GRUB gets multiple boot options,
rootfs is namespaced with subvolumes under `<root subvolume>/multifedora/...`,
secondary versions of `/boot` live under `/boot/multifedora/...`.
There's just one single ESP, the primary system owns it.
The primary system is placed normally and is oblivious of this madness
until you relegate it to a secondary by installing a new primary.

## Limitations

Assumes default encrypted btrfs Fedora Workstation disk layout,
with that last-century GRUB bootloader, ESP partition, all that cruft.
If you've installed Fedora with graphics, that's the defaults currently.

## Installation

```
dnf copr enable asosedkin/multifedora
dnf install multifedora multifedora-chroot
```

## Disclaimer

MAKE SURE YOUR BACKUPS ARE UP TO DATE FIRST,
SOMEWHERE WHERE THIS SOFTWARE CANNOT EAT THEM.
