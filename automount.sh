#!/bin/bash
lsblk -o NAME,SIZE,TYPE,MOUNTPOINT,UUID
echo "                                 "
echo -e "\033[32mplease run this script as root, you can switch to root using sudo su\033[0m"
echo "         "
echo "insert disk UUID"
read -r UUID

echo "                                 "

echo "insert mount point"
read -r mount

echo "                                 "


echo "insert filesystem type"
read -r fs

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
fi
