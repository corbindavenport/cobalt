#!/bin/bash

sudo mkdir /media/floppydrive
sudo mount -o loop,rw "$PWD/cdroot/isolinux/btdsk.img" /media/floppydrive

echo "Press ENTER when you are ready to un-mount the image."
read -sn1 input
sudo umount /media/floppydrive
sudo rm -rf /media/floppydrive