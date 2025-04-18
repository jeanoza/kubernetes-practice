#!/bin/bash

# $1: master ip
# $2: node1 ip
# $3: node2 ip

echo "[TASK 1] update & install utility packages"
apt-get update -y
apt-get install -y inxi neofetch containerd net-tools

echo "[TASK 2] hosts file setting"
echo "127.0.0.1   localhost" | tee /etc/hosts
echo "$1 master.example.com master" | tee -a /etc/hosts
echo "$2 node1.example.com node1" | tee -a /etc/hosts
echo "$3 node2.example.com node2" | tee -a /etc/hosts

chmod 600 /etc/netplan/50-vagrant.yaml # to avoid warning too open
netplan apply 


echo "[TASK 3] configuration before install k8s"

echo "[TASK 3-1] ip fowarding"
echo -e "overlay\nbr_netfilter" | tee /etc/modules-load.d/k8s.conf
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

echo "[TASK 4-2] initialize k8s cluster and create join command to use on worker"
kubeadm init --apiserver-advertise-address=$1 \
    --pod-network-cidr=10.244.0.0/16 \
    # --ignore-preflight-errors=NumCPU
rm -rf /vagrant/join_command.sh
kubeadm token create --print-join-command > /vagrant/join_command.sh

echo "[TASK 4-3] apply network plugin"
export KUBECONFIG=/etc/kubernetes/admin.conf
kubectl apply -f /vagrant/kube-flannel.yml

echo "[TASK 4-4] config in order to use k8s without sudo"
VAGRANT_HOME="/home/vagrant"
KUBE_DIR="$VAGRANT_HOME/.kube"
KUBE_CONFIG="$KUBE_DIR/config"
mkdir -p "$KUBE_DIR"
cp -i /etc/kubernetes/admin.conf "$KUBE_CONFIG"
# to avoid permission denied when using kubectl context
chown "$(id -u vagrant):$(id -g vagrant)" "$KUBE_DIR" 
chown "$(id -u vagrant):$(id -g vagrant)" "$KUBE_CONFIG" 


echo "[TASK 4-5] kubectl autocompletion"
echo "source <(kubectl completion bash)" >> "$VAGRANT_HOME/.bashrc"
echo "source <(kubeadm completion bash)" >> "$VAGRANT_HOME/.bashrc" 
source "$VAGRANT_HOME/.bashrc"


echo "[TASK 5] Configuration done"