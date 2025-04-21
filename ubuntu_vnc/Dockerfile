# Use Ubuntu 24.04 LTS as base image
FROM ubuntu:24.04

# Set environment variables to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update package list and install necessary packages
RUN apt-get update && apt-get install -y \
    xfce4 \
    xfce4-goodies \
    tightvncserver \
    network-manager-l2tp \
    network-manager-l2tp-gnome \
    network-manager-strongswan \
    network-manager-vpnc \
    network-manager-vpnc-gnome \
    firefox \
    sudo \
    bash \
    net-tools \
    iputils-ping \
    && rm -rf /var/lib/apt/lists/*

# Create a user and set password
RUN useradd -m -s /bin/bash vncuser && \
    echo "vncuser:vncuser" | chpasswd && \
    usermod -aG sudo vncuser

# Set up VNC
USER vncuser
WORKDIR /home/vncuser
RUN mkdir -p .vnc && \
    echo "vncuser" | vncpasswd -f > .vnc/passwd && \
    chmod 600 .vnc/passwd && \
    echo "#!/bin/bash\nxrdb $HOME/.Xresources\nstartxfce4 &" > .vnc/xstartup && \
    chmod +x .vnc/xstartup

# Expose VNC port
EXPOSE 5901

# Set up entrypoint
USER root
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]