FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install GUI, VPN tools, editors, bash features
RUN apt-get update && apt-get install -y \
    xfce4 xfce4-goodies tightvncserver \
    network-manager network-manager-gnome network-manager-l2tp-gnome \
    dbus-x11 x11-xserver-utils sudo curl nano vim wget \
    bash-completion iproute2 unzip git \
    xfce4-terminal xterm \
    && apt-get clean

# Add user 'docker' and give sudo
RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo

# Set VNC password and permissions
RUN mkdir -p /home/docker/.vnc && \
    echo "docker" | vncpasswd -f > /home/docker/.vnc/passwd && \
    chmod 600 /home/docker/.vnc/passwd && \
    echo '#!/bin/bash\nxrdb $HOME/.Xresources\nstartxfce4 &' > /home/docker/.vnc/xstartup && \
    chmod +x /home/docker/.vnc/xstartup && \
    chown -R docker:docker /home/docker/.vnc

# Enable bash completion for all users
RUN echo '\n# Bash completion\nif [ -f /etc/bash_completion ]; then\n  . /etc/bash_completion\nfi' >> /etc/bash.bashrc

# Create PolicyKit rule for VPN editing
RUN mkdir -p /etc/polkit-1/localauthority/50-local.d/ && \
    echo "[Allow docker user to manage network connections]\n\
Identity=unix-user:docker\n\
Action=org.freedesktop.NetworkManager.*\n\
ResultAny=yes\n\
ResultInactive=yes\n\
ResultActive=yes" > /etc/polkit-1/localauthority/50-local.d/10-network-manager.pkla

# Copy and fix permissions for startup
COPY startup.sh /home/docker/startup.sh
RUN chmod +x /home/docker/startup.sh && chown docker:docker /home/docker/startup.sh

# Expose VNC port
EXPOSE 5901

ENV DISPLAY=:1
CMD ["/home/docker/startup.sh"]
