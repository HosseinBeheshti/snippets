#!/bin/bash

# Set VNC password (ensure this is secure)
VNC_PASSWD="MyDockerTest"
echo "Setting VNC password..."
mkdir -p /home/ubuntu/.vnc
echo "$VNC_PASSWD" | vncpasswd -f > /home/ubuntu/.vnc/passwd
chmod 600 /home/ubuntu/.vnc/passwd

# Create the xstartup script for VNC
echo "Creating VNC xstartup script..."
cat << EOF > /home/ubuntu/.vnc/xstartup
#!/bin/sh

# Log file for xstartup debugging
XSTARTUP_LOG="/home/ubuntu/.vnc/xstartup.log"
echo "--- xstartup started at \$(date) ---" > \$XSTARTUP_LOG
echo "DISPLAY variable is initially: \$DISPLAY" >> \$XSTARTUP_LOG

# Explicitly set DISPLAY (vncserver should do this, but let's be sure)
export DISPLAY=:1
echo "DISPLAY variable set to: \$DISPLAY" >> \$XSTARTUP_LOG

# Unset potentially problematic session variables
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
export XDG_CURRENT_DESKTOP="XFCE"
export XDG_SESSION_TYPE=x11

# Source environment variables to ensure PATH is set correctly
echo "Sourcing profile..." >> \$XSTARTUP_LOG
[ -r /etc/profile ] && . /etc/profile
echo "Sourcing bashrc..." >> \$XSTARTUP_LOG
[ -r /home/ubuntu/.bashrc ] && . /home/ubuntu/.bashrc
echo "PATH is now: \$PATH" >> \$XSTARTUP_LOG

# Add a small delay to allow the X server to fully initialize
echo "Waiting 1 second..." >> \$XSTARTUP_LOG
sleep 1

# Attempt to load X resources (optional, but good test)
echo "Running xrdb..." >> \$XSTARTUP_LOG
xrdb -merge /home/ubuntu/.Xresources >> \$XSTARTUP_LOG 2>&1

# Start the XFCE desktop environment in the background
echo "Starting XFCE (startxfce4)..." >> \$XSTARTUP_LOG
startxfce4 >> \$XSTARTUP_LOG 2>&1 &

echo "--- xstartup finished at \$(date) ---" >> \$XSTARTUP_LOG
EOF
chmod +x /home/ubuntu/.vnc/xstartup

# Start D-Bus session bus (important for many desktop components)
# Run this in the main script's environment, not xstartup
echo "Starting D-Bus session..."
eval $(dbus-launch --sh-syntax)
export DBUS_SESSION_BUS_ADDRESS

# Start VNC server on display :1
echo "Starting VNC server on display :1..."

# Use -fg to run in foreground if tailing logs isn't desired, but tailing is usually better for Docker
vncserver :1 -geometry 1280x800 -depth 24 -localhost no -log /home/ubuntu/.vnc/vncserver.log

# Keep the container running and display logs
echo "VNC server started. Tailing logs..."
# Tail both the main VNC server log and the xstartup log
tail -f /home/ubuntu/.vnc/*.log
