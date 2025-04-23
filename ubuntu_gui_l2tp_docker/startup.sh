#!/bin/bash

# Start essential services
service dbus start
service NetworkManager start

# Copy Xauthority for root GUI access
cp /home/docker/.Xauthority /root/.Xauthority 2>/dev/null || true
chown root:root /root/.Xauthority

# Start VNC server
su - docker -c "vncserver :1 -geometry 1920x1080 -depth 24"

# Grant root GUI access
su - docker -c "xhost +SI:localuser:root"

# Keep container running
tail -f /dev/null
