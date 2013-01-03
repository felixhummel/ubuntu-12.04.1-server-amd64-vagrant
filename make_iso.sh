#!/bin/bash

set -e

# mirrors: https://launchpad.net/ubuntu/+cdmirrors
if [[ ! -f ubuntu-12.04.1-server-amd64.iso ]]; then
  wget http://ftp.tu-clausthal.de/pub/mirror/ubuntu/releases/12.04.1/ubuntu-12.04.1-server-amd64.iso
  wget http://ftp.tu-clausthal.de/pub/mirror/ubuntu/releases/12.04.1/MD5SUMS
  grep ubuntu-12.04.1-server-amd64.iso MD5SUMS > iso.md5
  md5sum -c iso.md5
fi


# -------[ root ]-------
sudo -H bash

mount -o loop ubuntu-12.04.1-server-amd64.iso /mnt
cp -a /mnt/ unpacked_iso
umount /mnt

mkdir initrd
cd initrd/
gunzip -c ../unpacked_iso/install/initrd.gz | cpio -id
cp ../preseed.cfg .
find . | cpio --create --format='newc' | gzip  > "../unpacked_iso/install/initrd.gz"
cd ..
rm -r initrd

cp isolinux.cfg unpacked_iso/isolinux/isolinux.cfg

cp late_command.sh unpacked_iso/

mkisofs -r -V "Ubuntu Server 12.04.1 Vagrant" \
  -cache-inodes -quiet \
  -J -l -b isolinux/isolinux.bin \
  -c isolinux/boot.cat -no-emul-boot \
  -boot-load-size 4 -boot-info-table \
  -o ubuntu-12.04.1-server-amd64-vagrant.iso unpacked_iso

rm -r unpacked_iso/

exit
# -------[ end root ]--------

sudo chown `id -u`:`id -g` ubuntu_server_12.04_vagrant.iso



exit 0



cd custom_server_iso/
vim README.diskdefines 
mv install/initrd.gz install/initrd.gz.orig
sudo mv install/initrd.gz install/initrd.gz.orig
sudo -H bash
sudo chown `id -u`:`id -g` ../ubuntu_server_12.04_vagrant.iso 
cd ..
mv ubuntu_server_12.04_vagrant.iso preseed/
cd preseed/
BOX="ubuntu-precise-64"
mkdir vbox
FOLDER_VBOX=vbox
mkdir iso
mv ubuntu_server_12.04_vagrant.iso 
mv ubuntu_server_12.04_vagrant.iso iso/
mv iso/ custom
FOLDER_ISO=custom
VBoxManage --help
VBoxManage --help | less
man VBoxManage
VBoxManage --help | less
VBoxManage showvminfo
VBoxManage showvminfo staging
VBoxManage showvminfo staging|less
VBoxManage storagectl addievm --name "IDE Controller" --add ide
VBoxManage storagectl   VBoxManage storagectl $BOX --name "IDE Controller" --add ide --name "IDE Controller" --add ide
echo $FOLDER_ISO 
ls $FOLDER_ISO 
VBoxManage --help | less
VBoxManage unregistervm $BOX --delete
vim make_vbox.sh
history > /tmp/x

