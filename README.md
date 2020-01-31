Void Linux Installer
---
LEAN Installer script as a alternative for default `void-installer`.

### FEATURES
- Automated process for LEAN installation of Void Linux UEFI MUSL
- Doesn't install any Desktop Environment
- Options for custom install in `installer.sh` header
- Formating `/` with `xfs filesystem`
- With `GIT`, `UFW` and `GRUB`
- Enable automatically DHCP and SSH server daemons (and internet working on next reboot)
- `/home` stay in a separated partition
- With options (`ext3`, `ext4` and `xfs`) to select file system to format `/` and '/home' partitions
- Swappiness option enabled (but not working - I guess that is a BUG)
- ~~Doesn't set up a common user~~

### USAGE
- Boot from Void Linux Live Image with a DE (Desktop Environment)
- Open terminal and install `git`: `sudo xbps-install -Sy git`<sup>1</sup>
- `sudo git clone http://github.com/marciliocn/void-installer`
- `cd void-installer`
- Edit the header of `installer.sh` to your taste
- `sudo ./installer.sh`
- Eject the installation media from drive and boot the machine
- ~~To enable internet after restart, run: `ln -s /etc/sv/dhcpcd /var/service/`~~
- Enjoy ;)

### INFOS
- Tested only:
	- In VirtualBox Machine
	- With UEFI MUSL
	- Arch x86_64
- <sup>1</sup> Using `void-live-x86_64-musl-20181111.iso` (without DE) in this step show "Transaction aborted due to insufficient disk space (need XXXMB, got XXMB free)". That's why use a Live Image with DE
- The version `void-live-x86_64-musl-20191109[-lxqt].iso` getting error with this installation
- The installation process running about 15 min
- To enable firewall, `sudo ufw enable` when log in new user

### TODO
- [ ] Create process installation for Void Linux BIOS/MBR MUSL
- [ ] Include /home partition in MBR installation
- [x] Add a pos-install script for automate tuning and another configs
- [x] Add a option to choose filesystem for partitions (don't forget to change in fstab too)
- [ ] Automatic answer for import keys (on first time repository sync)
- [ ] Include `rEFInd`
- [ ] Option to install without `GRUB` (on Arch it is possible)
- [ ] Finish installation musl full crypto with lvm (LUKS + LVM) (encryption for both `boot` and `root` partitions)
- [ ] Comparing partitions size from MB and KB (choose the best representative - in KB, necessary conversion)
- [ ] Test changing to sh indeed bash (on shebang)
- [ ] Finish installation glibc crypto with lvm
- [ ] Validate with glibc and musl installation
- [ ] Add flag to crypt or normal installation
- [ ] Include brazilian portuguese language option (and `us` too with International English)
- [ ] Option to scape partitioning and formating device
- [ ] Verifiy if SWAP is cryptographied (see https://wiki.archlinux.org/index.php/Dm-crypt/Swap_encryption)
- [ ] Add /home as a cryptographied partition (only /boot and / are cryptografied). See void-install-uefi on Joplin
- [ ] Insert a for loop to open and crypto partitions (starting in "echo "[!] Encrypt boot partition"" line - like in "for FS in ${!LV[@]}; do" line)
- [ ] Option o install with local repository
- [ ] Update the DEVNAME process to choose with `lsblk | grep -a '^[^l][a-z]' | cut -d ' ' -f 1` (removing hard coded)
- [ ] Add TXT files with Keymaps, Timezone, Lang, etc....in root directory as reference

### CHANGELOG
#### 202001.04
- Added HOME partition
- Adjust for all CHROOT commands on the same file
- Added options (`ext3`, `ext4` and `xfs`) to select file system to format `/` and '/home' partitions
- Added swappiness option (with bug and do not working - waiting)
#### 202001.03
- Added audio group in user creation script
- Added update mirror for new installation (the same choosen to install)
- Include Uncomplicated Firewall (ufw)
#### 202001.02
- Remove TTYs from 3 to 6
- Added user and configs for sudo usage
- Adjust in /etc/rc.conf
#### 202001.01
- Added activation for DHCP and SSH server deamons
#### 201903.01
- MVP for installer, without cryptography