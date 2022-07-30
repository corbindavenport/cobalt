#!/bin/bash
# This is for quickly testing a Cobalt USB image

DIR="$(dirname $0)"

# Check that QEMU is installed
if ! [ -x "$(command -v qemu-system-i386)" ]; then
  echo "QEMU is not installed. Run: sudo apt install qemu-kvm"
  exit
fi

# Run QEMU
qemu-system-i386 -m 32 -k en-us -rtc base=localtime -soundhw sb16,adlib -device cirrus-vga -display gtk -hda "$DIR/dist/cobalt-usb.img" -boot order=c