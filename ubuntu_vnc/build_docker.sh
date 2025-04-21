#!/bin/bash
mkdir -p docker
cd docker
touch Dockerfile

wget https://raw.githubusercontent.com/hossenibeheshti/ubuntu-vnc-l2tp/main/Dockerfile

snap install docker

docker build -t hossenibeheshti/ubuntu-vnc-l2tp:24.04 .

docker run -d \
  --name ubuntu-vnc \
  -p 5901:5901 \
  -e USER=docker \
  --user docker \
  hosseinbeheshti/ubuntu-vnc-l2tp:24.04


sudo ss -tuln | grep 5901