#!/bin/bash

# Name: Void Linux Installer
# Authors: Marcílio Nascimento <marcilio.mcn at gmail.com>
# Date: 2019, March
# Description: Alternative install script that replaces the standard Void Linux installer.
# License: MIT
# Version: 
# Changelog: 

# TODO:
# - Finish installation musl full crypto with lvm (LUKS + LVM) (encryption for both `boot` and `root` partitions)
# - Include /home partition in MBR installation
# - Comparing partitions size from MB and KB (choose the best representative - in KB, necessary conversion)
# - Teste changing to sh indeed bash (on shebang)
# - Finish installation glibc crypto with lvm
# - Validate with glibc and musl installation
# - Add flag to crypt or normal installation
# - Include brazilian portuguese language option (and both with International English)
# - Add TXT files with Keymaps, Timezone, Lang, etc....in root directory as reference
# - Option to scape partitioning and formating device
# - Verifiy if SWAP is cryptografied (see https://wiki.archlinux.org/index.php/Dm-crypt/Swap_encryption)
# - Add /home as a cryptografied partition (only /boot and / are cryptografied). See void-install-uefi on Joplin
# - Insert a for loop to open and crypto partitions (starting in "echo "[!] Encrypt boot partition"" line - like in "for FS in ${!LV[@]}; do" line)
# - Option o install with local repository
# - Update the DEVNAME process to choose with `lsblk | grep -a '^[^l][a-z]' | cut -d ' ' -f 1` (removing hard coded)

# Exit immediately if a command exits with a non-zero exit status
set -e

clear
echo '######################################'
echo '######## Void Linux Installer ########'
echo '######################################'
echo ''

# Explicitely declare our LV array (for LVM)
# declare -A LV

# Declare constants and variables
# REPO="http://alpha.us.repo.voidlinux.org/current"
REPO='http://mirror.clarkson.edu/voidlinux'
#DEVNAME="sda"
# VGNAME="vgpool"
# CRYPTSETUP_OPTS=""
UPDATETYPE='-Sy' # If GenuineIntel update local repository, change the next one to only '-y'
SWAP=1 # 1=On, 0=Off
# Partitions Size
EFISIZE='100M'
SWAPSIZE='1G'
BOOTSIZE='512M' # 512MB for /boot should be sufficient to host 7 to 8 kernel versions
ROOTSIZE='5G'
# LVM Size ARRAY (testing)
# LV[root]="2G"
# LV[var]="2G" - Test if necessary for desktop
# LV[home]="1G"
# Settings
HOSTNAME='gladiator' # pick your favorite name
HARDWARECLOCK='UTC' # Set RTC to UTC or localtime.???
KEYMAP='us' # Include another options here
TIMEZONE='America/Sao_Paulo'
LANG='en_US.UTF-8'
PKG_LIST='grub'

# Option to select the device type/name
PS3='Select your device type/name: '
options=('sda' 'sdb' 'nvme')
select opt in "${options[@]}"
do
  case $opt in
    'sda')
      DEVNAME='/dev/sda'
      break
      ;;
    'sdb')
      DEVNAME='/dev/sdb'
      break
      ;;
    'nvme')
      DEVNAME='/dev/nvme'
      break
      ;;
    *) echo 'The option "$opt" is invalid.';;
  esac
done

# Wipe /dev/${DEVNAME} (return this when the installation process is working)
#dd if=/dev/zero of=/dev/${DEVNAME} bs=1M count=100

# Detect if we're in UEFI or legacy mode installation
[ -d /sys/firmware/efi ] && UEFI=1

###### PARTITIONS - START ######
# Device Paritioning for UEFI/GPT or BIOS/MBR
# if [ $UEFI ]; then
#   sfdisk /dev/sda <<-EOF
#     label: gpt
#     ,$EFISIZE,U,*
#     ,$SWAPSIZE,S
#     ,$BOOTSIZE,L
#     ,$ROOTSIZE,L
#     ,,L
#   EOF
# else
#   sfdisk /dev/sda <<-EOF
#     label: dos
#     ,$SWAPSIZE,S
#     ,$BOOTSIZE,L,*
#     ,,L
#   EOF
# fi
###### PARTITIONS - END ######

# PARTITIONS
sfdisk $DEVNAME <<-EOF
  label: gpt
  ,$EFISIZE,U,*
  ,$SWAPSIZE,S
  ,,L
EOF

# FORMATING
mkfs.vfat -F 32 -n EFI ${DEVNAME}1
mkswap -L swp0 ${DEVNAME}2
mkfs.xfs -f -L voidlinux ${DEVNAME}3

# MOUNTING
mount ${DEVNAME}3 /mnt
mkdir /mnt/boot && mount ${DEVNAME}1 /mnt/boot

# When UEFI
mkdir /mnt/boot/efi && mount ${DEVNAME}1 /mnt/boot/efi

###### LVM AND CRYPTOGRAFY - START ######

# # Options for encrypt partitions process
# if [ $UEFI ]; then
#   BOOTPART="3"
#   ROOTPART="4"
# else
#   BOOTPART="2"
#   ROOTPART="3"
# fi

# # Start PKG_LIST variable and increase packages by the process installation
# PKG_LIST="lvm2 cryptsetup"

# # Install requirements for LVM and Cryptografy
# xbps-install -Syf $PKG_LIST

# echo "Encrypt - boot partition"
# cryptsetup ${CRYPTSETUP_OPTS} luksFormat -c aes-xts-plain64 -s 512 /dev/${DEVNAME}${BOOTPART}

# echo "Open - boot partition"
# cryptsetup luksOpen /dev/${DEVNAME}${BOOTPART} crypt-boot

# echo "Encrypt - root partition"
# cryptsetup ${CRYPTSETUP_OPTS} luksFormat -c aes-xts-plain64 -s 512 /dev/${DEVNAME}${ROOTPART}

# echo "Open - root partition"
# cryptsetup luksOpen /dev/${DEVNAME}${ROOTPART} crypt-pool

# # Create VolumeGroup
# pvcreate /dev/mapper/crypt-pool
# vgcreate ${VGNAME} /dev/mapper/crypt-pool
# for FS in ${!LV[@]}; do
#   lvcreate -L ${LV[$FS]} -n ${FS/\//_} ${VGNAME}
# done

# # If exist SWAP, create LV drive
# [ $SWAP -eq 1 ] && lvcreate -L ${SWAPSIZE} -n swap ${VGNAME}
# #if [ $SWAP -eq 1 ]; then
# #  lvcreate -L ${SWAPSIZE} -n swap ${VGNAME}
# #fi

# # Format filesystems
# [ $UEFI ] && mkfs.vfat /dev/${DEVNAME}1
# #if [ $UEFI ]; then
# #  mkfs.vfat /dev/${DEVNAME}1
# #fi

# mkfs.ext4 -L boot /dev/mapper/crypt-boot

# for FS in ${!LV[@]}; do
#   mkfs.ext4 -L ${FS/\//_} /dev/mapper/${VGNAME}-${FS/\//_}
# done

# if [ $SWAP -eq 1 ]; then
#   mkswap -L swap /dev/mapper/${VGNAME}-swap
# fi


# # Mount them
# mount /dev/mapper/${VGNAME}-root /mnt

# for dir in dev proc sys boot; do
#   mkdir /mnt/${dir}
# done

# ## Remove root and sort keys
# unset LV[root]

# for FS in $(for key in "${!LV[@]}"; do printf '%s\n' "$key"; done| sort); do
#   mkdir -p /mnt/${FS}
#   mount /dev/mapper/${VGNAME}-${FS/\//_} /mnt/${FS}
# done

# if [ $UEFI ]; then
#   mount /dev/mapper/crypt-boot /mnt/boot
#   mkdir /mnt/boot/efi
#   mount /dev/${DEVNAME}1 /mnt/boot/efi
# else
#   mount /dev/mapper/crypt-boot /mnt/boot
# fi

# for fs in dev proc sys; do
#   mount -o bind /${fs} /mnt/${fs}
# done

# # ?????????
# mkdir -p /mnt/var/db/xbps/keys/
# cp -a /var/db/xbps/keys/* /mnt/var/db/xbps/keys/

###### LVM AND CRYPTOGRAFY - END ######

###### PREPARING VOID LINUX INSTALLING PACKAGES ######
# If UEFI installation, add GRUB specific package
[ $UEFI ] && PKG_LIST="${PKG_LIST}-x86_64-efi"

# Detect if we're on an Intel system
CPU_VENDOR=$(grep vendor_id /proc/cpuinfo | uniq | awk '{print $3}')

clear
echo ''
echo 'Arquitetura: '$CPU_VENDOR
sleep 3

# If GenuineIntel, install void-repo-nonfree, add package for this architecture in $PKG_LIST and update the xbps-install type for installation
if [ $CPU_VENDOR == 'GenuineIntel' ]; then
  clear
  echo ''
  echo 'Detected GenuineIntel Arch. Adding new repo and Package to install.'
  xbps-install $UPDATETYPE -r /mnt void-repo-nonfree
  PKG_LIST='$PKG_LIST intel-ucode'
  UPDATETYPE='-y'
fi

# Install Void Linux
clear
echo ''
echo 'Installing Void Linux files.'
env XBPS_ARCH=x86_64-musl xbps-install $UPDATETYPE -R ${REPO}/current/musl -r /mnt base-system $PKG_LIST

# Upon completion of the install, we set up our chroot jail, and chroot into our mounted filesystem:
mount -t proc proc /mnt/proc
mount -t sysfs sys /mnt/sys
mount -o bind /dev /mnt/dev
mount -t devpts pts /mnt/dev/pts
cp -L /etc/resolv.conf /mnt/etc/

######################
### CHROOTed START ###
######################
clear
echo ''
echo 'Set Root Password'
# create the password for the root user
chroot /mnt passwd root

clear
echo ''
echo 'Adjust/Correct Root Permissions'
chroot /mnt chown root:root /
chroot /mnt chmod 755 /

clear
echo ''
echo 'Customizations'
# customization
echo $HOSTNAME > /mnt/etc/hostname
echo 'TIMEZONE="$TIMEZONE"' >> /mnt/etc/rc.conf
echo 'KEYMAP="$KEYMAP"' >> /mnt/etc/rc.conf
echo 'TTYS=2' >> /mnt/etc/rc.conf


##################################################
#### GLIBC ONLY - START - USE GLIBC IMAGE ISO ####
##################################################

# modify /etc/default/libc-locales and uncomment:
#en_US.UTF-8 UTF-8

# Or whatever locale you want to use. And run:
#xbps-reconfigure -f glibc-locales

# OLD CONFIGS
# echo "LANG=$LANG" > /mnt/etc/locale.conf
# echo "$LANG $(echo ${LANG} | cut -f 2 -d .)" >> /mnt/etc/default/libc-locales
# chroot /mnt xbps-reconfigure -f glibc-locales
# OLD CONFIGS


# cat >$ROOT/tmp/bootstrap.sh <<-EOCHROOT
# . /etc/profile
# sed -i 's/^#en_US/en_US/' /etc/default/libc-locales
# echo "root:$RPASSWD"|chpasswd -c SHA512
# xbps-reconfigure -f glibc-locales
# xbps-install -R $REPO -Sy base-system grub $EXTRAS
# [ -d /boot/grub ] || mkdir -p /boot/grub
# grub-mkconfig > /boot/grub/grub.cfg
# grub-install $DEV
# ln -s /etc/sv/dhcpcd /etc/runit/runsvdir/default/
# ln -s /etc/sv/sshd /etc/runit/runsvdir/default/
# EOCHROOT

# chroot $ROOT /bin/sh /tmp/bootstrap.sh
##########################
#### GLIBC ONLY - END ####
##########################

clear
echo ''
echo 'FSTAB'
###############################
#### FSTAB ENTRIES - START ####
###############################
#
# echo "<file system> <dir> <type>  <options>   <dump>  <pass>" >> /mnt/etc/fstab
echo 'tmpfs   /tmp  tmpfs defaults,nosuid,nodev   0       0' >> /mnt/etc/fstab
echo 'LABEL=EFI /boot vfat  rw,fmask=0133,dmask=0022,noatime,discard  0 2' >> /mnt/etc/fstab
echo 'LABEL=voidlinux / xfs rw,relatime,discard 0 1' >> /mnt/etc/fstab
echo 'LABEL=swp0  swap  swap  defaults    0 0' >> /mnt/etc/fstab

# For a removable drive I include the line:
# LABEL=volume  /media/blahblah xfs rw,relatime,nofail 0 0
# The important setting here is ***nofail***.
#############################
#### FSTAB ENTRIES - END ####
#############################

# echo "LABEL=root  /       ext4    rw,relatime,data=ordered,discard    0 0" > /mnt/etc/fstab
# echo "LABEL=boot  /boot   ext4    rw,relatime,data=ordered,discard    0 0" >> /mnt/etc/fstab

# for FS in $(for key in "${!LV[@]}"; do printf '%s\n' "$key"; done| sort); do
#   echo "LABEL=${FS/\//_}  /${FS}	ext4    rw,relatime,data=ordered,discard    0 0" >> /mnt/etc/fstab
# done

# echo "tmpfs       /tmp    tmpfs   size=1G,noexec,nodev,nosuid     0 0" >> /mnt/etc/fstab

# Write on FSTAB if is an UEFI installation
# [ $UEFI ] && echo "/dev/${DEVNAME}1   /boot/efi   vfat    defaults    0 0" >> /mnt/etc/fstab
#if [ $UEFI ]; then
#  echo "/dev/${DEVNAME}1   /boot/efi   vfat    defaults    0 0" >> /mnt/etc/fstab
#fi

# Write on FSTAB if SWAP partition exist
# [ $SWAP -eq 1 ] && echo "LABEL=swap  none       swap     defaults    0 0" >> /mnt/etc/fstab
#if [ $SWAP -eq 1 ]; then
#  echo "LABEL=swap  none       swap     defaults    0 0" >> /mnt/etc/fstab
#fi

# Install GRUB
# cat << EOF >> /mnt/etc/default/grub
# GRUB_TERMINAL_INPUT="console"
# GRUB_TERMINAL_OUTPUT="console"
# GRUB_ENABLE_CRYPTODISK=y
# EOF
# sed -i 's/GRUB_BACKGROUND.*/#&/' /mnt/etc/default/grub
# chroot /mnt grub-install /dev/${DEVNAME}

# LUKS_BOOT_UUID="$(lsblk -o NAME,UUID | grep ${DEVNAME}${BOOTPART} | awk '{print $2}')"
# LUKS_DATA_UUID="$(lsblk -o NAME,UUID | grep ${DEVNAME}${ROOTPART} | awk '{print $2}')"
# echo "GRUB_CMDLINE_LINUX=\"rd.vconsole.keymap=${KEYMAP} rd.lvm=1 rd.luks=1 rd.luks.allow-discards rd.luks.uuid=${LUKS_BOOT_UUID} rd.luks.uuid=${LUKS_DATA_UUID}\"" >> /mnt/etc/default/grub

clear
echo ''
echo 'Install GRUB'
# Install GRUB to the disk
chroot /mnt grub-install $DEVNAME

# clear
# echo "Configurar GRUB"
# # Generate the configuration file
# chroot /mnt grub-mkconfig -o /mnt/boot/grub/grub.cfg

clear
echo ''
echo 'Read the newest kernel'
# Cat the Linux Kernel Version and Reconfigure
KERNEL_VER=$(chroot /mnt xbps-query -s 'linux[0-9]*' | cut -f 2 -d ' ' | cut -f 1 -d -)

clear
echo ''
echo 'Reconfigure initramfs'
# Setup the kernel hooks (ignore grup complaints about sdc or similar)
chroot /mnt xbps-reconfigure -f $KERNEL_VER

clear
echo ''
echo 'Correct the grub install'
chroot /mnt update-grub

# exit
####################
### CHROOTed END ###
####################

# grub-mkconfig > /boot/grub/grub.cfg
# grub-install $DEV

# Bugfix for EFI installations (after finished, poweroff e poweron, the system do not start)
[ $UEFI ] && install -D /mnt/boot/efi/EFI/void/grubx64.efi /mnt/boot/efi/EFI/BOOT/bootx64.efi
#if [ $UEFI ]; then
#  install -D /mnt/boot/efi/EFI/void/grubx64.efi /mnt/boot/efi/EFI/BOOT/bootx64.efi
#fi

# Now add customization to installation - return this after succefully installation
#echo "[!] Running custom scripts"
#if [ -d ./custom ]; then
#  cp -r ./custom /mnt/tmp

#  # If we detect any .sh let's run them in the chroot
#  for SHFILE in /mnt/tmp/custom/*.sh; do
#    chroot /mnt sh /tmp/custom/$(basename $SHFILE)
#  done

#  # Then cleanup chroot
#  rm -rf /mnt/tmp/custom
#fi

umount -R /mnt

clear
echo ''
echo '####################################################'
echo '######## Void Linux Installed Successfully! ########'
echo '####################################################'

poweroff