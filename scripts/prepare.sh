#!/bin/bash

# HACK
# mount -o rw,dev,remount,exec,symfollow,suid /opt/games/usr

cd /opt/games/usr/waydroid

mkdir -p /opt/games/run/waydroid/pulse
mkdir -p /opt/games/usr/waydroid/images
mkdir -p /opt/games/usr/waydroid/data
mkdir -p /tmp/waydroid/scripts
mkdir -p /tmp/waydroid/tools
mkdir -p /opt/games/run/waydroid/rootfs

cp /opt/games/usr/waydroid/tools/* /tmp/waydroid/tools/
chmod 0755 /tmp/waydroid/tools/*
chmod +s /tmp/waydroid/tools/cage

cp /opt/games/usr/waydroid/scripts/* /tmp/waydroid/scripts/
chmod 0755 /tmp/waydroid/scripts/*

. /opt/games/usr/waydroid/scripts/rc.apparmor.functions
apparmor_stop

PIPEWIRE_NODE=amethyst DISPLAY=:0 XDG_RUNTIME_DIR=/var/run/pipewire PULSE_RUNTIME_PATH=/opt/games/run/waydroid/pulse /tmp/waydroid/tools/cage pipewire-pulse
