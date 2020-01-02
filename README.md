Void Linux Installer
---
Alternative install script that replaces the standard Void Linux installer.

### Features
- Automated process installation for Void Linux UEFI MUSL
- Doesn't install any Desktop Environment
- Doesn't set up a common user
- Formating `/` with `xfs filesystem`
- With GRUB

### Usage
- Boot from Void Linux Live Image with a DE (Desktop Environment)
- Open terminal and install Git: `sudo xbps-install -Sy git`<sup>1</sup>
- `git clone http://github.com/marciliocn/void-installer`
- `cd void-installer`
- Edit the header of `install.sh` to your taste
- `sudo ./install.sh`
- Eject the installation media from drive and boot the machine
- To enable internet after restart, run: `ln -s /etc/sv/dhcpcd /var/service/`

### INFOS
- Tested only in VirtualBox
- <sup>1</sup> Using `void-live-x86_64-musl-20181111.iso` (without DE) in this step show "Transaction aborted due to insufficient disk space (need XXXMB, got XXMB free)". That's why use a Live Image with DE.
- The installation process running about 30 min.

### TODO
- Create process installation for Void Linux BIOS/MBR MUSL
- Create a pos-install script for automate tuning and another configs

### CHANGELOG
#### Version 201901.01
- MVP for installer, without cryptography
