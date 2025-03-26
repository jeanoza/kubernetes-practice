#!/bin/bash

# $1: master ip
# $2: node1 ip
# $3: node2 ip

echo "[TASK 1] update & install utility packages"
apt-get update -y
apt-get install -y inxi neofetch containerd

echo "[TASK 2] hosts file setting"
echo "127.0.0.1   localhost" | tee /etc/hosts
echo "$1 master.example.com master" | tee -a /etc/hosts
echo "$2 node1.example.com node1" | tee -a /etc/hosts
echo "$3 node2.example.com node2" | tee -a /etc/hosts

chmod 600 /etc/netplan/50-vagrant.yaml # to avoid warning too open


echo "[TASK 3] configuration before install k8s"

echo "[TASK 3-1] ip fowarding"
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
sysctl -p

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
# weave network
kubeadm init --apiserver-advertise-address=$1
rm -rf /vagrant/join_command.sh
kubeadm token create --print-join-command > /vagrant/join_command.sh

echo "[TASK 4-3] apply network plugin"
export KUBECONFIG=/etc/kubernetes/admin.conf
# weave network
kubectl apply -f "https://reweave.azurewebsites.net/k8s/v1.32/net.yaml"

echo "[TASK 4-4] config in order to use k8s without sudo"
VAGRANT_HOME="/home/vagrant"
KUBE_CONFIG="$VAGRANT_HOME/.kube/config"
mkdir -p "$VAGRANT_HOME/.kube"
cp -i /etc/kubernetes/admin.conf "$KUBE_CONFIG"
chown "$(id -u vagrant):$(id -g vagrant)" "$KUBE_CONFIG"
chmod 600 "$KUBE_CONFIG"


echo "[TASK 5] Configuration done"