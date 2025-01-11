#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
echo -e "\033[32mplease switch to the root user using 'sudo su' command and try again\033[0m"
exit 3
fi

clear
echo "do you want to mount a disk or unmount it"
echo "1) mount"
echo "2) unmount"
read -r answer
case $answer in
1)
clear
lsblk -o NAME,SIZE,TYPE,MOUNTPOINT,UUID
echo "                                 "

echo "insert disk UUID (the IDs on the right of the disk)"
read -r UUID

echo "                                 "

echo "insert mount point (what folder you want the disk to be stored in. eg.. /home/eheea/HDD)"
read -r mount

echo "                                 "


echo "insert filesystem type (eg..ntfs,ext4,btrfs)"
read -r fs

sudo umount UUID="$UUID"

if [ ! -d "$mount" ]; then
mkdir -p "$mount"
echo "mount point has been created at $mount"
else  echo "mount point already exists"
fi

if ! grep -q "$UUID" /etc/fstab; then
echo "                                                          "
echo UUID="$UUID"  "$mount"  "$fs"  defaults  0  0 >> /etc/fstab
sudo systemctl daemon-reload
sudo mount UUID="$UUID"
if [ $? -eq 0 ]; then
echo "disk mounted successfully"
else echo "disk mount failed"
sed -i '$d' /etc/fstab
fi
else echo "disk is already mounted"
fi ;;

2)
clear
lsblk -o NAME,SIZE,TYPE,MOUNTPOINT,UUID
echo "                   "
echo -e "\033[32minsert the UUID of the disk you want to unmount\033[0m"
read -r ID
umount UUID="$ID"
if [ $? -eq 0 ]; then
echo "disk successfully unmounted"
else echo "if the disk didnt unmount correctly after this script please close all apps using the disk or restart your pc and try again"
fi
sed -i "/$ID/g" /etc/fstab
systemctl daemon-reload ;;
*) echo "not a valid entry. please try again"
esac