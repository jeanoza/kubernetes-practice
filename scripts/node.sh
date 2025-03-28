#!/bin/bash

# $1: master ip
MASTER_IP=$1
NODE_IP=$(hostname -I | awk '{print $2}')


echo "[TASK 1] update & install utility packages"
apt-get update -y
apt-get install -y inxi neofetch containerd net-tools

echo "[TASK 2] hosts file setting"
echo "127.0.0.1   localhost" | tee /etc/hosts
echo "$MASTER_IP master.example.com master" | tee -a /etc/hosts

chmod 600 /etc/netplan/50-vagrant.yaml # to avoid warning too open

echo "[TASK 3] configuration before install k8s"

echo "[TASK 3-1] ip fowarding"
modprobe overlay
modprobe br_netfilter
tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
sysctl --system

echo "[TASK 3-2] desactivate swap memory"
swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

echo "[TASK 3-3] config containerd"
mkdir -p /etc/containerd
containerd config default | tee /etc/containerd/config.toml >/dev/null
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml

# This is for override version :need or not?
sed -i 's|sandbox_image = ".*"|sandbox_image = "registry.k8s.io/pause:3.10"|g' /etc/containerd/config.toml

systemctl restart containerd
systemctl enable containerd


echo "[TASK 4] k8s"

echo "[TASK 4-1] install and hold"
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list
apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

echo "[TASK 4-2] join to master"

if [ -f /vagrant/join_command.sh ]; then
    echo "KUBELET_EXTRA_ARGS=--node-ip=$NODE_IP" | sudo tee /etc/default/kubelet
    bash /vagrant/join_command.sh
fi

echo "[TASK 5] Configuration done"
