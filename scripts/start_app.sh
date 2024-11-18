#!/bin/bash

CMD="cmd package resolve-activity --brief $1 | tail -n 1"
ACTIVITY=$(lxc-attach -P /opt/games/usr/waydroid/lxc -n waydroid -- /system/bin/sh -c "$CMD")
echo "Launching: $1"
echo "ACTIVITY: $ACTIVITY"
ARG="service call waydroidplatform 7 s16 $1"
lxc-attach -P /opt/games/usr/waydroid/lxc -n waydroid -- /system/bin/sh -c "$ARG"
