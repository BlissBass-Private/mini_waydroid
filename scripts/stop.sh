#!/bin/bash

rm /opt/games/run/waydroid/waydroid.prop
lxc-stop -P /home/waydroid/lxc -n waydroid -k
/tmp/waydroid/scripts/waydroid-net.sh stop
umount -l /opt/games/run/waydroid/rootfs || true
