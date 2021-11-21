#!/usr/bin/env bash

set -eo pipefail

image_name="arch-linux-arm-$(date "+%F").img"

sudo rm /mnt/etc/resolv.conf
sudo mv /mnt/etc/resolv.conf.bak /mnt/etc/resolv.conf

sudo umount /mnt/boot
sudo umount /mnt
sudo losetup --detach "/dev/loop0"

mv "custom-pi.img" "$image_name"

xz -z -k -9 -e -T 0 -v "$image_name"

gsutil cp "${image_name}.xz" gs://pi-images.serenacodes.com/
