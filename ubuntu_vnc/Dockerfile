FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Install desktop, VNC, VPN, and RDP
RUN apt update && apt install -y \
    xfce4 xfce4-goodies x11vnc xvfb \
    openssl sudo curl net-tools iputils-ping \
    strongswan xl2tpd network-manager \
    remmina freerdp2-x11 \
    dbus-x11 && \
    apt clean

# Set up a VNC password
RUN mkdir -p /root/.vnc && \
    x11vnc -storepasswd "Asal@7770" /root/.vnc/passwd

# Generate self-signed cert for VNC encryption
RUN openssl req -x509 -newkey rsa:4096 -keyout /root/vnc.key -out /root/vnc.crt -days 365 -nodes -subj "/CN=localhost"

# Combine key and cert for x11vnc
RUN cat /root/vnc.key /root/vnc.crt > /root/vnc.pem

# Startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 1998

CMD ["/start.sh"]
