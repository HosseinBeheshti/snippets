#!/bin/bash

# Start VNC server as ubuntu user with logging
su - ubuntu -c "vncserver :1 -geometry 1280x800 -depth 24 -localhost no -Log *:stderr:100"

# Check if VNC server started
if netstat -tuln | grep -q 5901; then
    echo "VNC server is running on port 5901"
else
    echo "Failed to start VNC server"
    exit 1
fi

# Keep the container running
tail -f /dev/null