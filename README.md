Void Linux Installer
---
Installer script as a alternative for default `void-installer`.

### FEATURES
- Automated process installation for Void Linux UEFI MUSL
- Doesn't install any Desktop Environment
- Doesn't set up a common user
- Formating `/` with `xfs filesystem`
- With GRUB

### USAGE
- Boot from Void Linux Live Image with a DE (Desktop Environment)
- Open terminal and install Git: `sudo xbps-install -Sy git`<sup>1</sup>
- `git clone http://github.com/marciliocn/void-installer`
- `cd void-installer`
- Edit the header of `00-install.sh` to your taste
- `sudo ./00-install.sh`
- Eject the installation media from drive and boot the machine
- To enable internet after restart, run: `ln -s /etc/sv/dhcpcd /var/service/`

### INFOS
- Tested only in VirtualBox and with UEFI MUSL
- <sup>1</sup> Using `void-live-x86_64-musl-20181111.iso` (without DE) in this step show "Transaction aborted due to insufficient disk space (need XXXMB, got XXMB free)". That's why use a Live Image with DE.
- The installation process running about 15 min.

### TODO
- Create process installation for Void Linux BIOS/MBR MUSL
- Add a pos-install script for automate tuning and another configs
- Automatic answer for import keys
- Include `rEFInd`
- Option to install without GRUB or UEFI (on Arch it is possible)

### CHANGELOG
#### Version 201901.01
- MVP for installer, without cryptography
