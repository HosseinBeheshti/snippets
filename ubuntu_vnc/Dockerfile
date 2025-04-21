FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive \
    USER=docker \
    PASSWORD=docker \
    HOME=/home/docker

# Install packages
RUN apt-get update && apt-get install -y \
    xfce4 xfce4-goodies \
    tigervnc-standalone-server \
    dbus-x11 \
    xterm \
    sudo \
    network-manager network-manager-gnome \
    network-manager-l2tp-gnome \
    wget curl net-tools \
    && apt-get clean

# Add user
RUN useradd -m -s /bin/bash $USER && \
    echo "$USER:$PASSWORD" | chpasswd && \
    usermod -aG sudo $USER

USER $USER
WORKDIR /home/$USER

# Setup VNC password
RUN mkdir -p /home/$USER/.vnc && \
    echo $PASSWORD | vncpasswd -f > /home/$USER/.vnc/passwd && \
    chmod 600 /home/$USER/.vnc/passwd

# Create xstartup file
RUN echo '#!/bin/sh\n\
xrdb $HOME/.Xresources\n\
startxfce4 &' > /home/$USER/.vnc/xstartup && \
    chmod +x /home/$USER/.vnc/xstartup

EXPOSE 5901

# Startup VNC automatically
CMD ["bash", "-c", "vncserver :1 -geometry 1920x1080 -depth 24 && tail -f /home/docker/.vnc/*.log"]
