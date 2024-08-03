#!/bin/bash

# HACK
# mount -o rw,dev,remount,exec,symfollow,suid /home

cd /home/waydroid

mkdir -p /opt/games/run/waydroid/pulse
mkdir -p /home/waydroid/images
mkdir -p /home/waydroid/data
mkdir -p /tmp/waydroid/scripts
mkdir -p /tmp/waydroid/tools
mkdir -p /opt/games/run/waydroid/rootfs

cp /home/waydroid/tools/* /tmp/waydroid/tools/
chmod 0755 /tmp/waydroid/tools/*
chmod +s /tmp/waydroid/tools/cage

cp /home/waydroid/scripts/* /tmp/waydroid/scripts/
chmod 0755 /tmp/waydroid/scripts/*

. /home/waydroid/scripts/rc.apparmor.functions
apparmor_stop

DISPLAY=:0 XDG_RUNTIME_DIR=/var/run/pipewire PULSE_RUNTIME_PATH=/opt/games/run/waydroid/pulse /tmp/waydroid/tools/cage pipewire-pulse
