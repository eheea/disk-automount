#!/bin/bash
echo "                     "
echo -e "\033[32mplease run this script as root, you can switch to root using sudo su\033[0m"
echo "do you want to mount a disk or unmount it"
echo "1) mount"
echo "2) unmount"
read -r answer
case $answer in
1)
echo "          "
lsblk -o NAME,SIZE,TYPE,MOUNTPOINT,UUID
echo "                                 "

echo "insert disk UUID"
read -r UUID

echo "                                 "

echo "insert mount point"
read -r mount

echo "                                 "


echo "insert filesystem type"
read -r fs

sudo umount UUID=$UUID

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
echo "             "
lsblk -o NAME,SIZE,TYPE,MOUNTPOINT,UUID
echo "                   "
echo -e "\033[32minsert the UUID of the disk you want to unmount\033[0m"
read -r ID
umount UUID="$ID"
if [ $? -eq 0 ]; then
echo "disk successfully unmounted"
else echo "the disk is busy. log out or restart the computer and try again"
fi
sed -i "/$ID/g" /etc/fstab
systemctl daemon-reload ;;
*) echo "not a valid entry. please try again"
esac