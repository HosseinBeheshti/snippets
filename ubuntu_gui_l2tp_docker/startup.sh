#!/bin/bash

# Start essential services
mkdir -p /var/run/dbus
dbus-uuidgen > /var/lib/dbus/machine-id
dbus-daemon --config-file=/usr/share/dbus-1/system.conf --print-address

service dbus start
service NetworkManager start

# Wait for NetworkManager to start
sleep 3

# Copy Xauthority for root GUI access
cp /home/docker/.Xauthority /root/.Xauthority 2>/dev/null || true
chown root:root /root/.Xauthority

# Start VNC server
su - docker -c "vncserver :1 -geometry 1920x1080 -depth 24"

# Grant root GUI access
su - docker -c "xhost +SI:localuser:root"

# Start polkit authentication agent
export $(dbus-launch)
/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &

# Keep container running
tail -f /dev/null