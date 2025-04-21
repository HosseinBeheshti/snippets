#!/bin/bash
mkdir ubuntu-vnc-l2tp
cd ubuntu-vnc-l2tp

wget https://raw.githubusercontent.com/hossenibeheshti/ubuntu-vnc-l2tp/main/Dockerfile
wget https://raw.githubusercontent.com/hossenibeheshti/ubuntu-vnc-l2tp/main/entrypoint.sh

docker build -t hossenibeheshti/ubuntu-vnc-l2tp:24.04 .

docker push hossenibeheshti/ubuntu-vnc-l2tp:24.04
