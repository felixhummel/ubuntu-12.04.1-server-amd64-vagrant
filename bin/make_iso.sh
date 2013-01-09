#!/bin/bash

set -e

# mirrors: https://launchpad.net/ubuntu/+cdmirrors
if [[ ! -f ubuntu-12.04.1-server-amd64.iso ]]; then
  echo 'get iso'
  wget http://ftp.tu-clausthal.de/pub/mirror/ubuntu/releases/12.04.1/ubuntu-12.04.1-server-amd64.iso
  wget http://ftp.tu-clausthal.de/pub/mirror/ubuntu/releases/12.04.1/MD5SUMS
  grep ubuntu-12.04.1-server-amd64.iso MD5SUMS > iso.md5
  md5sum -c iso.md5
fi


# -------[ root ]-------
echo 'unpack iso'
mount -o loop ubuntu-12.04.1-server-amd64.iso /mnt
cp -a /mnt/ unpacked_iso
umount /mnt

echo 'patch initrd'
mkdir initrd
cd initrd/
gunzip -c ../unpacked_iso/install/initrd.gz | cpio -id
cp ../preseed.cfg .
find . | cpio --create --format='newc' | gzip  > "../unpacked_iso/install/initrd.gz"
cd ..
rm -r initrd

echo 'copy isolinux.cfg and late_command.sh'
cp isolinux.cfg unpacked_iso/isolinux/isolinux.cfg
cp late_command.sh unpacked_iso/

echo 'make iso'
mkisofs -r -V "Ubuntu Server 12.04.1 Vagrant" \
  -cache-inodes -quiet \
  -J -l -b isolinux/isolinux.bin \
  -c isolinux/boot.cat -no-emul-boot \
  -boot-load-size 4 -boot-info-table \
  -o ubuntu-12.04.1-server-amd64-vagrant.iso unpacked_iso

echo 'clean up'
rm -r unpacked_iso/
exit

