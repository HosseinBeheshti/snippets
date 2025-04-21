FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive \
    USER=docker \
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

# Add user (no password yet)
RUN useradd -m -s /bin/bash $USER && \
    usermod -aG sudo $USER

USER $USER
WORKDIR /home/$USER

# VNC startup file
RUN mkdir -p /home/$USER/.vnc && \
    echo '#!/bin/sh\n\
xrdb $HOME/.Xresources\n\
startxfce4 &' > /home/$USER/.vnc/xstartup && \
    chmod +x /home/$USER/.vnc/xstartup

EXPOSE 5901

# Entrypoint script to set password at runtime
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]



# Create xstartup file
RUN echo '#!/bin/sh\n\
xrdb $HOME/.Xresources\n\
startxfce4 &' > /home/$USER/.vnc/xstartup && \
    chmod +x /home/$USER/.vnc/xstartup

EXPOSE 5901

# Startup VNC automatically
CMD ["bash", "-c", "vncserver :1 -geometry 1280x800 -depth 24 && tail -f /home/docker/.vnc/*.log"]

