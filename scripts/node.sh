#!/bin/bash

# $1: master ip

echo "[TASK 1] update & install utility packages"
sudo apt-get update -y
sudo apt-get install -y inxi neofetch containerd

echo "[TASK 2] hosts file setting"
echo "127.0.0.1   localhost" | sudo tee /etc/hosts
echo "$1 master.example.com master" | sudo tee -a /etc/hosts

chmod 600 /etc/netplan/50-vagrant.yaml # to avoid warning too open

echo "[TASK 3] configuration before install k8s"

echo "[TASK 3-1] ip fowarding"
sudo sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
sudo sysctl -p

echo "[TASK 3-2] desactivate swap memory"
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

echo "[TASK 3-3] config containerd"
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml >/dev/null
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml
sudo systemctl restart containerd
sudo systemctl enable containerd


echo "[TASK 4] k8s"

echo "[TASK 4-1] install and hold"
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

echo "[TASK 4-2] join to master(to implement) using sudo"
echo "$(whoami)" >> /vagrant/whoami.txt
if [ -f /vagrant/join_command.sh ]; then
    bash /vagrant/join_command.sh
fi

echo "[TASK 5] Configuration done"
