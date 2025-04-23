FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install packages
RUN apt-get update && apt-get install -y \
    xfce4 xfce4-goodies tightvncserver \
    network-manager network-manager-gnome network-manager-l2tp-gnome \
    dbus-x11 x11-xserver-utils sudo curl nano wget iproute2 \
    && apt-get clean

# Create user
RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo

# Set up VNC password
RUN mkdir -p /home/docker/.vnc && \
    echo "hossein" | vncpasswd -f > /home/docker/.vnc/passwd && \
    chmod 600 /home/docker/.vnc/passwd && \
    chown -R docker:docker /home/docker/.vnc

# Create .vnc/xstartup to launch XFCE
RUN echo '#!/bin/bash\nxrdb $HOME/.Xresources\nstartxfce4 &' > /home/docker/.vnc/xstartup && \
    chmod +x /home/docker/.vnc/xstartup && \
    chown docker:docker /home/docker/.vnc/xstartup

# Copy startup script
COPY startup.sh /home/docker/startup.sh
RUN chmod +x /home/docker/startup.sh && chown docker:docker /home/docker/startup.sh

# Environment and expose VNC port
ENV DISPLAY=:1
EXPOSE 5901

CMD ["/home/docker/startup.sh"]