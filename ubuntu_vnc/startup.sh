#!/bin/bash

# Start system services
service dbus start
service NetworkManager start

# Start VNC server for user 'docker'
su - docker -c "vncserver :1 -geometry 1280x800 -depth 24"

# Keep container alive
tail -f /dev/null
