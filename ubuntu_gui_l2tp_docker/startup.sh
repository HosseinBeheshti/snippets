#!/bin/bash

# Set VNC password
VNC_PASSWD="MyDockerTest"
echo "Setting VNC password..."
mkdir -p /home/ubuntu/.vnc
echo "$VNC_PASSWD" | vncpasswd -f > /home/ubuntu/.vnc/passwd
chmod 600 /home/ubuntu/.vnc/passwd

# Create xstartup script
echo "Creating VNC xstartup script..."
cat << 'EOF' > /home/ubuntu/.vnc/xstartup
#!/bin/sh

# Log file for xstartup debugging
XSTARTUP_LOG="/home/ubuntu/.vnc/xstartup.log"
echo "--- xstartup started at $(date) ---" > $XSTARTUP_LOG
echo "DISPLAY variable is initially: $DISPLAY" >> $XSTARTUP_LOG

# Explicitly set DISPLAY
export DISPLAY=:1
echo "DISPLAY variable set to: $DISPLAY" >> $XSTARTUP_LOG

# Unset potentially problematic session variables
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
export XDG_CURRENT_DESKTOP="XFCE"
export XDG_SESSION_TYPE=x11

# Source environment variables
echo "Sourcing profile..." >> $XSTARTUP_LOG
[ -r /etc/profile ] && . /etc/profile
echo "Sourcing bashrc..." >> $XSTARTUP_LOG
[ -r /home/ubuntu/.bashrc ] && . /home/ubuntu/.bashrc
echo "PATH is now: $PATH" >> $XSTARTUP_LOG

# Add a small delay
echo "Waiting 1 second..." >> $XSTARTUP_LOG
sleep 1

# Attempt to load X resources
echo "Running xrdb..." >> $XSTARTUP_LOG
xrdb -merge /home/ubuntu/.Xresources >> $XSTARTUP_LOG 2>&1 || true

# Start the XFCE desktop environment in the foreground
echo "Starting XFCE (startxfce4)..." >> $XSTARTUP_LOG
startxfce4 >> $XSTARTUP_LOG 2>&1

# This line will only be reached if startxfce4 exits
echo "--- xstartup finished at $(date) ---" >> $XSTARTUP_LOG
EOF
chmod +x /home/ubuntu/.vnc/xstartup

# Start D-Bus session bus
echo "Starting D-Bus session..."
eval $(dbus-launch --sh-syntax)
export DBUS_SESSION_BUS_ADDRESS

# Start VNC server
echo "Starting VNC server on display :1..."
vncserver :1 -geometry 1920x1080 -depth 24 -localhost no

# Keep the container running
echo "VNC server started. Tailing logs..."
tail -f /home/ubuntu/.vnc/*.log