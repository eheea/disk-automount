#!/bin/bash
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
systemctl daemon-reload