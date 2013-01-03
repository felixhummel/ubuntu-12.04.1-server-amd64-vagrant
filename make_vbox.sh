mkdir vbox

BOXNAME=ubuntu-12.04.1-server-amd64-vagrant

VBoxManage createvm \
  --name $BOXNAME \
  --ostype Ubuntu_64 \
  --register \
  --basefolder vbox

VBoxManage modifyvm $BOXNAME \
  --memory 2048 \
  --boot1 dvd \
  --boot2 disk \
  --boot3 none \
  --boot4 none \
  --vram 12 \
  --pae off \
  --rtcuseutc on

VBoxManage storagectl $BOXNAME \
  --name "IDE Controller" \
  --add ide \
  --controller PIIX4 \
  --hostiocache on

# create controller before attaching
# http://www.trimentation.com/wp/?p=85
VBoxManage storagectl $BOXNAME --name "IDE Controller" --add ide

VBoxManage storageattach $BOXNAME \
  --storagectl "IDE Controller" \
  --port 1 \
  --device 0 \
  --type dvddrive \
  --medium ubuntu-12.04.1-server-amd64-vagrant.iso

VBoxManage storagectl $BOXNAME \
  --name "SATA Controller" \
  --add sata \
  --controller IntelAhci \
  --sataportcount 1 \
  --hostiocache off

VBoxManage createhd \
  --filename vbox/$BOXNAME.vdi \
  --size 40960

VBoxManage storageattach $BOXNAME \
  --storagectl "SATA Controller" \
  --port 0 \
  --device 0 \
  --type hdd \
  --medium vbox/$BOXNAME.vdi

VBoxManage startvm $BOXNAME

# if you want to start over:
# VBoxManage unregistervm $BOXNAME --delete


