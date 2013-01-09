#!/bin/bash
set -e

mkdir -p vbox

boxname=$(bin/boxname.sh)
guestadditions=/usr/share/virtualbox/VBoxGuestAdditions.iso

VBoxManage createvm \
  --name $boxname \
  --ostype Ubuntu_64 \
  --register \
  --basefolder vbox

VBoxManage modifyvm $boxname \
  --memory 2048 \
  --boot1 dvd \
  --boot2 disk \
  --boot3 none \
  --boot4 none \
  --vram 12 \
  --pae off \
  --rtcuseutc on

VBoxManage storagectl $boxname \
  --name "IDE Controller" \
  --add ide \
  --controller PIIX4 \
  --hostiocache on

VBoxManage storageattach $boxname \
  --storagectl "IDE Controller" \
  --port 1 \
  --device 0 \
  --type dvddrive \
  --medium ubuntu-12.04.1-server-amd64-vagrant.iso

VBoxManage storagectl $boxname \
  --name "SATA Controller" \
  --add sata \
  --controller IntelAhci \
  --sataportcount 1 \
  --hostiocache off

VBoxManage createhd \
  --filename vbox/$boxname.vdi \
  --size 40960

VBoxManage storageattach $boxname \
  --storagectl "SATA Controller" \
  --port 0 \
  --device 0 \
  --type hdd \
  --medium vbox/$boxname.vdi

VBoxManage startvm $boxname

echo -n "Waiting for installer to finish "
while VBoxManage list runningvms | grep $boxname >/dev/null; do
  sleep 20
  echo -n "."
done
echo ""

VBoxManage modifyvm "$boxname" \
  --natpf1 "guestssh,tcp,,2222,,22"
VBoxManage storageattach "$boxname" \
  --storagectl "IDE Controller" \
  --port 1 \
  --device 0 \
  --type dvddrive \
  --medium $guestadditions

VBoxManage startvm "$boxname"

# get private key
curl --output id_rsa "https://raw.github.com/mitchellh/vagrant/master/keys/vagrant"
chmod 600 id_rsa

# install virtualbox guest additions
ssh -i id_rsa -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -p 2222 vagrant@127.0.0.1 "sudo mount /dev/cdrom /media/cdrom && sudo sh /media/cdrom/VBoxLinuxAdditions.run --nox11 && sudo umount /media/cdrom && sudo shutdown -h now"
echo -n "Waiting for machine to shut off "
while VBoxManage list runningvms | grep "$boxname" >/dev/null; do
  sleep 20
  echo -n "."
done
echo ""

VBoxManage modifyvm "$boxname" --natpf1 delete "guestssh"

# Detach guest additions iso
echo "Detach guest additions ..."
VBoxManage storageattach "$boxname" \
  --storagectl "IDE Controller" \
  --port 1 \
  --device 0 \
  --type dvddrive \
  --medium emptydrive


