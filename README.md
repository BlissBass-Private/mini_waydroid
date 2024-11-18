# Setup or Update
```
curl -s https://raw.githubusercontent.com/BlissBass-Private/mini_waydroid/refs/heads/main/setup.sh | bash
```

# Images
- Download images to /opt/games/usr/waydroid/images/

# Prepare
```
. /opt/games/usr/waydroid/scripts/prepare.sh
```

# Start
```
/tmp/waydroid/scripts/start.sh
```

# Add input

This needs to be done after starting Waydroid
```
/tmp/waydroid/scripts/add_inputs.sh
```

# Stop
```
/tmp/waydroid/scripts/stop.sh
```

# Shell
```
/tmp/waydroid/scripts/shell.sh
```

# Launch Apps
```
/tmp/waydroid/scripts/start_app.sh <app_name>
```
Example:
```
/tmp/waydroid/scripts/start_app.sh com.aurora.store
```

