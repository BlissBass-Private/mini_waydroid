#!/bin/bash

mkdir -p /tmp/waydroid
cd /tmp/waydroid
curl -O https://github.com/BlissBass-Private/mini_waydroid/archive/refs/heads/main.zip
unzip main.zip
mkdir -p /home/waydroid
cp -fpr main/* /home/waydroid/

rm -rf main.zip main
