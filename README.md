Void Linux Installer
---
LEAN Installer script as a alternative for default `void-installer`.

### FEATURES
- Automated process for LEAN installation of Void Linux UEFI MUSL
- Doesn't install any Desktop Environment
- Options for custom install in `void-musl.sh` header
- With `GIT`, `UFW` and `GRUB`
- Enable automatically DHCP and SSH server daemons (and internet work on next reboot)
- `/home` partition separated from `/`
- With file system options (`ext3`, `ext4` and `xfs`) to format `/` and `/home` partitions
- `sudo poweroff` and `sudo restart` without password
- Swappiness option enabled (but not working - I guess that is a BUG)
- Best for Desktop or Notebooks

### USAGE
- Boot from Void Linux Live Image <sup id="a1">[1](#f1)</sup> and log in as `root` (password `voidlinux`)
- Install `curl` with `xbps-install -Sy curl`
- Start installation:
	a. Without customizations: `bash -c "$(curl -L git.io/void-musl.sh)"`
	b. With customizations: `curl -LO git.io/void-musl.sh`
		- Edit the header of `void-musl.sh` file to your taste (using `vi` for example)
		- Make it executable with `chmod +x void-musl.sh`
		- `./void-musl.sh`
- After installation end, eject the installation media from drive and reboot the machine
- Enjoy ;)

> **Add `sudo` in front of all commands if you choose a Live Image WITH Desktop Environment**

### INFOS
- Tested:
	- In VirtualBox Machine on Intel Core i3-2367M 1.4GHz with 2 cores and RAM with 1024MB
	- With UEFI MUSL
	- In Arch x86_64
- The installation process running about 15 min
- To enable firewall, `sudo ufw enable` when log in new user

<sup id="f1">1</sup> [↩](#a1) With `void-live-x86_64-musl-20190526.iso` live image
	> `void-live-x86_64-musl-20191109[-lxqt].iso` live image didn't work: after `xbps-install -Sy curl`, show the message `Transaction aborted due to unresolved dependencies.`

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
- [ ] Option to install with local repository
- [ ] Update the DEVNAME process to choose with `lsblk | grep -a '^[^l][a-z]' | cut -d ' ' -f 1` (removing hard coded)
- [ ] Add TXT files with Keymaps, Timezone, Lang, etc....in root directory as reference

### CHANGELOG
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