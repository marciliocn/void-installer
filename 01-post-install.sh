#!/bin/bash

# Exit immediately if a command exits with a non-zero exit status
set -e

clear
echo '###########################################'
echo '######## Void Linux Post Installer ########'
echo '###########################################'
echo ''

# Declare constants and variables
# REPO="http://alpha.us.repo.voidlinux.org/current"
REPO='http://mirror.clarkson.edu/voidlinux'
UPDATETYPE='-Sy' # If GenuineIntel update local repository, change the next one to only '-y'
# Settings
HOSTNAME='gladiator' # pick your favorite name
HARDWARECLOCK='UTC' # Set RTC to UTC or localtime.???
KEYMAP='us' # Include another options here
TIMEZONE='America/Sao_Paulo'
LANG='en_US.UTF-8'
PKG_LIST=''

###### PREPARING VOID LINUX INSTALLING PACKAGES ######

# Detect if we're on an Intel system
CPU_VENDOR=$(grep vendor_id /proc/cpuinfo | uniq | awk '{print $3}')

# If GenuineIntel, install void-repo-nonfree, add package for this architecture in $PKG_LIST 
# and update the xbps-install type for installation
if [ $CPU_VENDOR == 'GenuineIntel' ]; then
  # clear
  echo ''
  echo 'Parameters dentro: '$UPDATETYPE
  echo 'Detected GenuineIntel Arch. Adding new repo and Package to install.'
  echo xbps-install $UPDATETYPE -r /mnt void-repo-nonfree
  sleep 5
  env XBPS_ARCH=x86_64-musl xbps-install $UPDATETYPE -R ${REPO}/current/musl -r /mnt void-repo-nonfree
  PKG_LIST+=' intel-ucode'
  echo 'Pacotes dentro: '$PKG_LIST
  sleep 6
  UPDATETYPE='-y'
  echo 'Parameters final: '$UPDATETYPE
  sleep 10
fi

clear
echo ''
echo 'Active DHCP deamon for enable network connection on next boot.'
chroot /mnt ln -s /etc/sv/dhcpcd /var/service

# Now add customization to installation - return this after succefully installation
#echo "[!] Running custom scripts"
#if [ -d ./custom ]; then
#  cp -r ./custom /mnt/tmp

#  # If we detect any .sh let's run them in the chroot
#  for SHFILE in /mnt/tmp/custom/*.sh; do
#    chroot /mnt sh /tmp/custom/$(basename $SHFILE)
#  done

clear
echo ''
echo '#########################################################'
echo '######## Void Linux Post Installed Successfully! ########'
echo '#########################################################'