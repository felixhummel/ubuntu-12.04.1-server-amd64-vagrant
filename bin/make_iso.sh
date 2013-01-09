#!/bin/bash
# run as root (KISS)

set -e

iso_url=${ISO_URL:-http://ftp.tu-clausthal.de/pub/mirror/ubuntu/releases/12.04.1/ubuntu-12.04.1-server-amd64.iso}
iso_file=$(basename $iso_url)
iso_seed=$(basename $iso_file .iso)-vagrant.iso

# mirrors: https://launchpad.net/ubuntu/+cdmirrors
if [[ ! -f $iso_file ]]; then
  echo 'get iso'
  wget $iso_url
  grep $iso_file MD5SUMS > iso.md5
  md5sum -c iso.md5
  rm iso.md5
fi

echo 'unpack iso'
mount -o loop $iso_file /mnt
cp -a /mnt/ build/unpacked_iso
umount /mnt

echo 'patch initrd'
oldwd=`pwd`
mkdir build/initrd
cd build/initrd/
gunzip -c $oldwd/build/unpacked_iso/install/initrd.gz | cpio -id
cp $oldwd/templates/preseed.cfg .
find . | cpio --create --format='newc' | gzip  > "$oldwd/build/unpacked_iso/install/initrd.gz"
cd $oldwd
rm -r build/initrd

echo 'copy isolinux.cfg and late_command.sh'
cp templates/isolinux.cfg build/unpacked_iso/isolinux/isolinux.cfg
cp templates/late_command.sh build/unpacked_iso/

echo 'make iso'
mkisofs -r -V "Ubuntu Server 12.04.1 Vagrant" \
  -cache-inodes -quiet \
  -J -l -b isolinux/isolinux.bin \
  -c isolinux/boot.cat -no-emul-boot \
  -boot-load-size 4 -boot-info-table \
  -o $iso_seed build/unpacked_iso

echo 'clean up'
rm -r build/unpacked_iso/
exit

