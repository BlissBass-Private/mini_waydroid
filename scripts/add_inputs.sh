#!/bin/bash

for file in /sys/devices/virtual/input/input*/event*/uevent; do
  echo add > "$file"
done

