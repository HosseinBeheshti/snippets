FROM ubuntu:24.04

# Avoid prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Update and install necessary packages
RUN apt-get update && apt-get install -y \
    sudo \
    wget \
    gnupg \
    lsb-release \
    curl \
    software-properties-common \
    net-tools \
    iputils-ping \
    openvpn \
    network-manager \
    network-manager-l2tp \
    network-manager-l2tp-gnome \
    xfce4 \
    xfce4-goodies \
    tightvncserver \
    dbus-x11 \
    x11-xserver-utils \
    && apt-get clean

# Create a user for VNC
RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo

# Set up VNC server for the docker user
USER docker
RUN mkdir -p /home/docker/.vnc
RUN echo "docker" | vncpasswd -f > /home/docker/.vnc/passwd && \
    chmod 600 /home/docker/.vnc/passwd

# Set VNC to start XFCE
RUN echo "#!/bin/bash\nstartxfce4 &" > /home/docker/.vnc/xstartup && \
    chmod +x /home/docker/.vnc/xstartup

# Expose VNC port
EXPOSE 5901

# Start VNC server on container start
CMD ["vncserver", ":1", "-geometry", "1280x800", "-depth", "24"]

