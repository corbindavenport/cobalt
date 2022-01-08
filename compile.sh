#!/bin/bash

PUBLISHER="Cobalt"
TITLE="Cobalt Live CD"

if ! [ -x "$(command -v mkisofs)" ]; then
  echo "Install mkisofs and run this script again."
  exit
fi

mkdir -p "$PWD/bin"
echo "Generating ISO..."
mkisofs -o "$PWD/bin/cobalt.iso" -publisher "$PUBLISHER" -V "$TITLE" -b isolinux/isolinux.bin -no-emul-boot -boot-load-size 4 -boot-info-table -c boot.cat cdroot

exit 0