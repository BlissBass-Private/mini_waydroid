#!/bin/bash

rm /opt/games/run/waydroid/waydroid.prop
export DISPLAY=:0
export XDG_RUNTIME_DIR=/opt/games/run/waydroid
export WAYLAND_DISPLAY=wayland-0

lxc-stop -P /home/waydroid/lxc -n waydroid -k
/tmp/waydroid/scripts/waydroid-net.sh stop

umount -l /opt/games/run/waydroid/rootfs || true

echo "Waydroid running on ${WAYLAND_DISPLAY}"
cp /home/waydroid/waydroid_base.prop /opt/games/run/waydroid/waydroid.prop

echo "waydroid.pulse_runtime_path=/run/waydroid/pulse" >> /opt/games/run/waydroid/waydroid.prop
echo "waydroid.xdg_runtime_dir=/run/waydroid" >> /opt/games/run/waydroid/waydroid.prop
echo "waydroid.wayland_display=${WAYLAND_DISPLAY}" >> /opt/games/run/waydroid/waydroid.prop

/tmp/waydroid/scripts/waydroid-net.sh start

chmod 0600 /opt/games/run/waydroid/waydroid.prop

mount /home/waydroid/images/system.img /opt/games/run/waydroid/rootfs
mount /home/waydroid/images/vendor.img /opt/games/run/waydroid/rootfs/vendor
mount -o bind /opt/games/run/waydroid/waydroid.prop /opt/games/run/waydroid/rootfs/vendor/waydroid.prop

mkdir -p /dev/binderfs
umount /dev/binderfs
mount -t binder binder /dev/binderfs
chmod 666 /dev/binderfs/*

chmod 777 -R ${XDG_RUNTIME_DIR}/pulse
chmod 777 -R /var/run/pipewire
chmod 777 -R /dev/dri/*
chmod 777 -R /dev/fb*

lxc-start -P /home/waydroid/lxc -n waydroid -F
