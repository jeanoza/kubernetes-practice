#!/bin/bash

echo "[TASK 1] update & install utility packages"
sudo apt-get update -y
sudo apt-get install -y inxi neofetch

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
chmod 600 /etc/netplan/50-vagrant.yaml


sudo netplan apply

echo "[TASK 3] hostname and hosts file setting"
echo "master.example.com" | sudo tee /etc/hostname
sudo hostnamectl set-hostname master.example.com

echo "127.0.0.1   localhost" | sudo tee /etc/hosts
echo "10.100.0.104 master.example.com" | sudo tee -a /etc/hosts

echo "[TASK 4] Configuration done!"
