FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    xfce4 \
    xfce4-goodies \
    xfce4-terminal \
    tightvncserver \
    network-manager-l2tp \
    network-manager-l2tp-gnome \
    network-manager-strongswan \
    dbus-x11 \
    x11-apps \
    x11-utils \
    x11-xserver-utils \
    sudo \
    bash \
    net-tools \
    iputils-ping \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash vncuser && \
    echo "vncuser:vncuser" | chpasswd && \
    usermod -aG sudo vncuser

USER vncuser
WORKDIR /home/vncuser
RUN mkdir -p .vnc && \
    echo "vncuser" | vncpasswd -f > .vnc/passwd && \
    chmod 600 .vnc/passwd && \
    echo "#!/bin/bash\nunset SESSION_MANAGER\nunset DBUS_SESSION_BUS_ADDRESS\n[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup\n[ -r \$HOME/.Xresources ] && xrdb \$HOME/.Xresources\nstartxfce4 &" > .vnc/xstartup && \
    chmod +x .vnc/xstartup

EXPOSE 5901

USER root
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]