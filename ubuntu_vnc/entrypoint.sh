#!/bin/bash

# Start VNC server as ubuntu user
su - ubuntu -c "vncserver :1 -geometry 1920x1080 -depth 24"

# Keep the container running
tail -f /dev/null