#!/bin/sh
# Only run this script AFTER adding new vdi drive (/dev/sdb)
# TODO: include script to create new vdi drive

if [ -b "/dev/sdb" ]; then
    if [ -b "/dev/sdb1" ]; then
        echo "The partition already created, ignore fdisk"
    else    
        echo "==> Creating new partition..."
        fdisk /dev/sdb <<EOL
n
p
1


w
EOL
    fi
else
    echo "You must create new disk and attach to this VM"
    exit
fi

if [ -b "/dev/sdb1" ]; then
    if [ -e "/mnt/mysql" ]; then
        echo "mysql folder is already moved. Nothing to do"
    else
        echo "==> Formatting partition..."
        mkfs.ext4 /dev/sdb1

        echo "==> Mounting new partition..."
        mkdir -p /mnt
        echo "" >> /etc/fstab
        echo "/dev/sdb1 /mnt ext4 defaults 0 2" >> /etc/fstab
        mount -a

        echo "==> Moving mysql folder..."
        service mysql stop
        echo "" >> /etc/mysql/conf.d/custom.cnf
        echo "datadir = /mnt/mysql" >> /etc/mysql/conf.d/custom.cnf
        echo "tmpdir = /mnt/tmp" >> /etc/mysql/conf.d/custom.cnf
        mv /var/lib/mysql /mnt/
        mkdir -m 0777 /mnt/tmp
        service mysql start
        echo "==> All done."
    fi
else
    echo "/dev/sdb1 is not exist. Likely that there is error in running fdisk"
fi