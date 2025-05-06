# Use Ubuntu 24.04 LTS (Noble Numbat) as the base image
FROM ubuntu:24.04

LABEL maintainer="HosseinBeheshti"
LABEL description="Ubuntu 24.04 Desktop (XFCE) with VNC"

# Prevent interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Set timezone (Optional, but recommended for GUI apps)
ENV TZ=Etc/UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Update package lists and install prerequisites
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    sudo \
    wget \
    locales \
    tzdata \
    dbus-x11 \
    # --- Desktop Environment and VNC ---
    xubuntu-desktop \
    tigervnc-standalone-server \
    tigervnc-common \
    tigervnc-tools \ 
    # --- Cleanup ---
    && apt-get autoclean && apt-get autoremove && rm -rf /var/lib/apt/lists/*

# Set up locale
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

# The ubuntu:24.04 base image often includes an 'ubuntu' user.
# Set a known password and ensure it's in the sudo group.
# Also ensure the home directory exists and has correct ownership.
RUN echo "ubuntu:ubuntu" | chpasswd && \
    usermod -aG sudo ubuntu && \
    mkdir -p /home/ubuntu && \
    chown -R ubuntu:ubuntu /home/ubuntu

# Allow the 'ubuntu' user to run sudo commands without a password
RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to the non-root user
USER ubuntu
WORKDIR /home/ubuntu

# Copy the startup script
COPY --chown=ubuntu:ubuntu startup.sh /startup.sh
RUN chmod +x /startup.sh

# Expose VNC port (Display :1 -> Port 5901)
EXPOSE 5901

# Set the default command to run the startup script
CMD ["/startup.sh"]