# Setup Ubuntu Server for VNC + L2TP VPN

Follow the steps below to set up an Ubuntu server with VNC and L2TP VPN support.

## Clone the Repository
```bash
# Clone the repository containing the necessary files
git clone https://github.com/HosseinBeheshti/snippets.git

# Navigate to the cloned repository
cd snippets

# Copy the [ubuntu_vnc_l2tp_docker](http://_vscodecontentref_/0) directory to a new location
cp -r ubuntu_vnc_l2tp_docker/ ../ubuntu-vnc-l2tp

# Navigate to the new directory
cd ../ubuntu-vnc-l2tp
```

```bash
chmod +x setup_server.sh
chmod +x startup.sh
```

```bash
./setup_server.sh
```

```bash
docker-compose up --build -d
```