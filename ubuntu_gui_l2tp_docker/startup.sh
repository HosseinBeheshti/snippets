#!/bin/bash
set -e

# Start D-Bus System Service (Needed by NetworkManager)
# Check if running as root for system service start
if [ "$(id -u)" = "0" ]; then
   echo "Error: This script should be run as the 'ubuntu' user, not root."
   exit 1
fi
# Attempt to start dbus using sudo
sudo service dbus start || echo "DBus already running or failed to start."

# VNC Password Setup
VNC_DIR="$HOME/.vnc"
VNC_PASSWD_FILE="$VNC_DIR/passwd"
VNC_STARTUP_FILE="$VNC_DIR/xstartup"
VNC_LOG_FILE="$HOME/.vnc/$(hostname):1.log" # Path depends on hostname inside container

mkdir -p "$VNC_DIR"
chmod 700 "$VNC_DIR"
touch "$VNC_PASSWD_FILE"
chmod 600 "$VNC_PASSWD_FILE"

# Set VNC password if VNC_PASSWORD env var is set
if [ -n "$VNC_PASSWORD" ]; then
  echo "Setting VNC password..."
  echo "$VNC_PASSWORD" | vncpasswd -f > "$VNC_PASSWD_FILE"
else
  echo "Warning: VNC_PASSWORD environment variable not set. VNC password not configured."
  echo "         You may need to set it manually on first connection or container start."
fi

# Create xstartup file if it doesn't exist
if [ ! -f "$VNC_STARTUP_FILE" ]; then
  echo "Creating default xstartup script..."
  cat <<EOF > "$VNC_STARTUP_FILE"
#!/bin/bash
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
# Fix for some keyboard layouts issues
export XKL_XMODMAP_DISABLE=1

# Source Xresources if it exists
[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup
[ -r \$HOME/.Xresources ] && xrdb \$HOME/.Xresources

# Start the XFCE Desktop Environment
startxfce4 &

# Start Network Manager Applet (for VPN GUI in panel)
nm-applet &
EOF
  chmod +x "$VNC_STARTUP_FILE"
fi

# Start TigerVNC Server
echo "Starting VNC server on display :1 (port 5901)..."
# -localhost no : Allows connections from any interface (needed due to Docker networking)
# -fg           : Runs VNC server in the foreground (Alternative to tailing log)
# -desktop name : Sets the name that appears in the VNC client
# -SecurityTypes VncAuth : Use standard VNC password authentication
vncserver :1 -geometry 1920x1080 -depth 24 -localhost no -SecurityTypes VncAuth -desktop UbuntuVNC

echo "VNC server started. Connect using VNC Client to <host-ip>:5901"
echo "Password is the value set in VNC_PASSWORD environment variable."

# Keep container running by tailing the VNC log file
echo "Tailing VNC log file: ${VNC_LOG_FILE}..."
# Wait a moment for the log file to be created
sleep 5
if [ -f "${VNC_LOG_FILE}" ]; then
  tail -f "${VNC_LOG_FILE}"
else
  echo "Warning: VNC log file not found at ${VNC_LOG_FILE}. Keeping container alive with sleep loop."
  # Fallback to keep container running if log file isn't found
  while true; do sleep 3600; done
fi