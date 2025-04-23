#!/bin/bash

# Start services
service dbus start
service NetworkManager start

# Set up Xauthority for root GUI access
cp /home/docker/.Xauthority /root/.Xauthority 2>/dev/null || true
chown root:root /root/.Xauthority

# Start VNC
su - docker -c "vncserver :1 -geometry 1920x1080 -depth 24"

# Allow root to connect to X
su - docker -c "xhost +SI:localuser:root"

# Drop into bash login shell for interaction
su - docker -c "bash --login"

# Keep container running
tail -f /dev/null