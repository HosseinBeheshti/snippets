FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install XFCE desktop, VNC server, L2TP VPN GUI, terminal emulators, bash completion
RUN apt-get update && apt-get install -y \
    xfce4 xfce4-goodies tightvncserver \
    network-manager network-manager-gnome network-manager-l2tp-gnome \
    xfce4-terminal xterm \
    bash-completion \
    dbus-x11 x11-xserver-utils sudo curl nano vim wget iproute2 unzip git \
    && apt-get clean

# Create a user
RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo

# Set up VNC password
RUN mkdir -p /home/docker/.vnc && \
    echo "docker" | vncpasswd -f > /home/docker/.vnc/passwd && \
    chmod 600 /home/docker/.vnc/passwd && \
    chown -R docker:docker /home/docker/.vnc

# Create VNC xstartup to launch XFCE
RUN echo '#!/bin/bash\nxrdb $HOME/.Xresources\nstartxfce4 &' > /home/docker/.vnc/xstartup && \
    chmod +x /home/docker/.vnc/xstartup && \
    chown docker:docker /home/docker/.vnc/xstartup

# Enable bash completion for the docker user
RUN echo "\n# Enable bash completion\nif [ -f /etc/bash_completion ]; then\n  . /etc/bash_completion\nfi" >> /home/docker/.bashrc && \
    chown docker:docker /home/docker/.bashrc

# Copy the startup script
COPY startup.sh /home/docker/startup.sh
RUN chmod +x /home/docker/startup.sh && chown docker:docker /home/docker/startup.sh

# Expose VNC port
EXPOSE 5901

# Set default display
ENV DISPLAY=:1

# Run the startup script
CMD ["/home/docker/startup.sh"]
