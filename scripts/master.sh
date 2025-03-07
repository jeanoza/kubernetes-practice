#!/bin/bash

# $1: master ip
# $2: node1 ip
# $3: node2 ip

echo "[TASK 1] update & install utility packages"
# docker package keyring
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update -y
sudo apt-get install -y inxi neofetch docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "[TASK 2] hostname and hosts file setting"
echo "master.example.com" | sudo tee /etc/hostname

echo "127.0.0.1   localhost" | sudo tee /etc/hosts
echo "$1 master.example.com master" | sudo tee -a /etc/hosts
echo "$2 node1.example.com node1" | sudo tee -a /etc/hosts
echo "$3 node2.example.com node2" | sudo tee -a /etc/hosts

chmod 600 /etc/netplan/50-vagrant.yaml # to avoid warning too open

echo "[TASK 3] Docker group config"
sudo usermod -aG docker vagrant # add current user in docker Group
newgrp docker # apply changed group

echo "[TASK 4] Configuration done"
