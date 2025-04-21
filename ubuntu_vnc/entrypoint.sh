#!/bin/bash

# Set default password if not provided
PASSWORD=${VNC_PASSWORD:-docker}

# Set user password
echo "docker:$PASSWORD" | chpasswd

# Setup VNC password
echo $PASSWORD | vncpasswd -f > /home/docker/.vnc/passwd
chmod 600 /home/docker/.vnc/passwd

# Start VNC
vncserver :1 -geometry 1280x800 -depth 24

# Keep container alive
tail -f /home/docker/.vnc/*.log
