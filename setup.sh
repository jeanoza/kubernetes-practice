#!/bin/bash

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

echo "[TASK 2] Network config(DHCP -> Static IP)"
sudo mkdir -p /etc/cloud/cloud.cfg.d
echo 'network: {config: disabled}' | sudo tee /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg

sudo tee /etc/netplan/01-netcfg.yaml > /dev/null <<EOF
network:
  version: 2
  ethernets:
    eth0:
      dhcp4: no
      addresses: [10.100.0.104/24]
      routes:
        - to: 0.0.0.0/0
          via: 10.100.0.1
      nameservers:
        addresses: [10.100.0.1]
EOF

chmod 600 /etc/netplan/01-netcfg.yaml
# chmod 600 /etc/netplan/50-vagrant.yaml

sudo netplan apply

echo "[TASK 3] hostname and hosts file setting"
echo "master.example.com" | sudo tee /etc/hostname

echo "127.0.0.1   localhost" | sudo tee /etc/hosts
echo "10.100.0.104 master.example.com master" | sudo tee -a /etc/hosts
echo "10.100.0.101 node1.example.com node1" | sudo tee -a /etc/hosts
echo "10.100.0.102 node2.example.com node2" | sudo tee -a /etc/hosts

echo "[TASK 4] Docker group config"
sudo usermod -aG docker $USER # add current user in docker Group
newgrp docker # apply changed group

echo "[TASK 5] Configuration done"
