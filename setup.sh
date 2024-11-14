#!/bin/bash

mkdir -p /tmp/waydroid
cd /tmp/waydroid
curl -O https://codeload.github.com/BlissBass-Private/mini_waydroid/zip/refs/heads/main
mv main mini_waydroid-main.zip
unzip mini_waydroid-main.zip
mkdir -p /opt/games/usr/waydroid
cp -fpr mini_waydroid-main/* /opt/games/usr/waydroid/

rm -rf mini_waydroid-main.zip mini_waydroid-main
