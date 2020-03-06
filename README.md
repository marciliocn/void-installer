Void Linux Installer
---
LEAN Installer script as a alternative for default `void-installer`.

### FEATURES
- Automated process for LEAN installation of Void Linux MUSL for GPT/UEFI or MBR/BIOS
- Doesn't install any Desktop Environment
- Options for custom install in `void-musl.sh` header
- Include: `GIT` and `GRUB` packages
- Enable automatically DHCP (and internet work on next reboot)
- Option to enable SSH server and Wipe Device
- `/home` partition separated from `/`
- With file system options (`ext2`, `ext3`, `ext4` and `xfs`) to format `/` and `/home` partitions
- `sudo poweroff` and `sudo restart` without password
- Swappiness option enabled (but not working - I guess that is a BUG)
- Best for Desktops or Notebooks

### USAGE
- Boot from Void Linux Live Image <sup id="a1">[1](#f1)</sup> and log in as `root` (password `voidlinux`)
- Install `curl` with `xbps-install -Sy curl`
- Start installation:
	- a. Without customizations: `bash <(curl -L git.io/void-musl.sh)`
	- b. With customizations: `curl -LO git.io/void-musl.sh`
		- Edit the header of `void-musl.sh` file to your taste (using `vi` for example)
		- Make it executable with `chmod +x void-musl.sh`
		- `./void-musl.sh`
- After installation end, eject the installation media from drive and reboot the machine
- Enjoy ;)

> **Add `sudo` in front of all commands if you choose a Live Image WITH Desktop Environment**

### INFOS
- Necessary Internet connection to install
- Tested:
	- In VirtualBox on Intel Core i3-2367M 1.4GHz with 2 cores and RAM with 1024MB
	- With UEFI MUSL
	- In Arch x86_64
	- <sup id="f1">1</sup> [↩](#a1) Recomendation: use the last live image (today is the published in `20191109`)
		> `void-live-x86_64-musl-20191109[-lxqt].iso` live image can not work: i.e. after `xbps-install -Sy curl`, show the message `Transaction aborted due to unresolved dependencies.` **(Edit: necessary update `xbps` and `libressl` packages before any step)**
- Use 512MB for EFISIZE should be sufficient to host 7 to 8 kernel versions (only 100MB do not work for another full kernel upgrade)
- The installation process running about 12 min in VirtualBox with SATA storage

### TODO
- [ ] Include `rEFInd`
- [ ] Option to install without `GRUB` (only without criptografy - on Arch it is possible)
- [ ] Finish installation musl full crypto with lvm (LUKS + LVM) (encryption for both `boot` and `root` partitions)
- [ ] Finish installation glibc crypto with lvm
- [ ] Validate with glibc and musl installation
- [ ] Add flag to crypt or normal installation
- [ ] Include brazilian portuguese language option (and `us` too with International English)
- [ ] Option to scape partitioning and formating device
- [ ] Verifiy if SWAP is cryptographied (see https://wiki.archlinux.org/index.php/Dm-crypt/Swap_encryption)
- [ ] Add /home as a cryptographied partition (only /boot and / are cryptografied). See void-install-uefi on Joplin
- [ ] Insert a for loop to open and crypto partitions (starting in "echo "[!] Encrypt boot partition"" line - like in "for FS in ${!LV[@]}; do" line)
- [ ] Option to install with local repository
- [ ] Add TXT files with Keymaps, Timezone, Lang, etc....in root directory as reference
- ~Change to sh indeed bash (on shebang)~
- [x] Update the DEVNAME process to choose with command (removing hard coded)
- [x] Comparing partitions size from MB and KB (choose the best representative - in KB, necessary conversion)
- [x] Create process installation for Void Linux BIOS/MBR MUSL
- [x] Include /home partition in MBR installation
- [x] Add a pos-install script for automate tuning and another configs
- [x] Add a option to choose filesystem for partitions (don't forget to change in fstab too)
- [X] Automatic answer for import keys (on first time repository sync)

### CHANGELOG
#### 202003.01
- Improved options for file system format
- Dynamic device selection (from devices connected)
- Automatic answer for import keys
- Installation adapted for MBR/BIOS
#### 202002.03
- Option to enable SSH Server
#### 202002.02
- Double check on input password for `root` and `user` defined in header
- Removed Uncomplicated Firewall (ufw)
#### 202002.01
- Change PS4 to PS3 to choose filesystem
- FSTAB check order on partitions
- Change for UUID indeed label partitions on FSTAB
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