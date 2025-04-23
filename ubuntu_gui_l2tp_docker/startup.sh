#!/bin/bash

# Start required services
service dbus start
service NetworkManager start

# Start VNC server for the docker user
su - docker -c "vncserver :1 -geometry 1920x1080 -depth 24"

# Set terminal emulator default (failsafe setup)
su - docker -c "xfconf-query -c xsettings -p /Default/TerminalEmulator -s xfce4-terminal || true"

# Keep container alive
tail -f /dev/null
