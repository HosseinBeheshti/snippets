#!/bin/bash
mkdir ubuntu-vnc-l2tp
cd ubuntu-vnc-l2tp

docker build -t hossenibeheshti/ubuntu-vnc-l2tp:24.04 .

docker push hossenibeheshti/ubuntu-vnc-l2tp:24.04
