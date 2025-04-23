FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install core packages
RUN apt-get update && apt-get install -y \
    sudo xfce4 xfce4-goodies tightvncserver \
    network-manager network-manager-gnome network-manager-l2tp-gnome \
    bash-completion nano vim curl wget git xterm dbus-x11 \
    && apt-get clean

# Add non-root user
RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo

# Setup bash completion
RUN echo 'if [ -f /etc/bash_completion ]; then . /etc/bash_completion; fi' >> /home/docker/.bashrc && \
    cp /home/docker/.bashrc /root/.bashrc

# Set VNC password & startup
RUN mkdir -p /home/docker/.vnc && \
    echo "docker" | vncpasswd -f > /home/docker/.vnc/passwd && \
    chmod 600 /home/docker/.vnc/passwd && \
    echo -e '#!/bin/sh\nxrdb $HOME/.Xresources\nstartxfce4 &' > /home/docker/.vnc/xstartup && \
    chmod +x /home/docker/.vnc/xstartup && \
    chown -R docker:docker /home/docker/.vnc

# Add polkit JS rule for full network control
RUN mkdir -p /etc/polkit-1/rules.d && \
    echo "polkit.addRule(function(action, subject) { if (subject.isInGroup('sudo')) { return polkit.Result.YES; } });" > /etc/polkit-1/rules.d/49-nm.rules

# Add startup script
COPY startup.sh /home/docker/startup.sh
RUN chmod +x /home/docker/startup.sh && chown docker:docker /home/docker/startup.sh

# Expose VNC
EXPOSE 5901
ENV DISPLAY=:1

CMD ["/home/docker/startup.sh"]
