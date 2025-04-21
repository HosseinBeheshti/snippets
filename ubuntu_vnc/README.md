# Build and Push Ubuntu VNC L2TP Docker Image

This document outlines the steps to build a Docker image named `hossenibeheshti/ubuntu-vnc-l2tp:24.04` and push it to Docker Hub.

## Prerequisites

*   Docker installed on your system.
*   A Docker Hub account.
*   A `Dockerfile` in the project directory.

## Steps

1.  **Create Project Directory**
    Create a directory for the project and navigate into it:
    ````bash
    mkdir ubuntu-vnc-l2tp
    cd ubuntu-vnc-l2tp
    ````

2.  **Create Dockerfile**
    Create or place your `Dockerfile` in the `ubuntu-vnc-l2tp` directory. You can use an editor like `vim`:
    ````bash
    vim Dockerfile
    ````
    *(Ensure your Dockerfile content is defined here)*

3.  **Install Docker (if needed)**
    If Docker is not installed, you can install it using various methods. One way on systems supporting Snap is:
    ````bash
    snap install docker
    ````
    *(Refer to the official Docker documentation for other installation methods: [https://docs.docker.com/engine/install/](https://docs.docker.com/engine/install/))*

4.  **Build the Docker Image**
    Build the image using the `Dockerfile` in the current directory (`.`) and tag it:
    ````bash
    docker build -t hossenibeheshti/ubuntu-vnc-l2tp:24.04 .
    ````
    *(Replace `hossenibeheshti/ubuntu-vnc-l2tp:24.04` with your desired image name and tag)*

5.  **Log in to Docker Hub**
    Log in to your Docker Hub account using your credentials:
    ````bash
    docker login
    ````
    *(You will be prompted for your username and password/token)*

6.  **Push the Docker Image**
    Push the locally built image to Docker Hub:
    ````bash
    docker push hossenibeheshti/ubuntu-vnc-l2tp:24.04
    ````
    *(Ensure the image name matches the one used in the build step and corresponds to your Docker Hub repository)*