#!/bin/bash
lsblk -o NAME,SIZE,TYPE,MOUNTPOINT,UUID
echo "insert the UUID of the disk you want to unmount"
read -r ID
umount UUID="$ID"
sed -i "/$ID/d" /etc/fstab
