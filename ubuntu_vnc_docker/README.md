# Setup Ubuntu Server for VNC + L2TP VPN

Follow the steps below to set up an Ubuntu server with VNC.

## Clone the Repository
```bash
# Clone the repository containing the necessary files
git clone https://github.com/HosseinBeheshti/snippets.git

# Navigate to the cloned repository
cd snippets

cp -r ubuntu_vnc_docker/ ../ubuntu-vnc

# Navigate to the new directory
cd ../ubuntu-vnc
```

```bash
chmod +x setup_server.sh
chmod +x startup.sh
```

```bash
./setup_server.sh
```

```bash
# Build with your tag
docker-compose build

# Login to Docker Hub
docker login

# Push your image
docker push hosseinbeheshti/ubuntu-vnc:latest

# (Optional) Run it
docker-compose up -d

```