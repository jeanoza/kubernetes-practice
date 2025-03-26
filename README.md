### TODO list

- Master VM

0. install package utility

1. config network(dhcp -> static address)

  - ip address: 10.100.0.104

  - netmask: 24

  - gateway: 10.100.0.1

  - dns: 10.100.0.1

  - To create and write

    -  `/etc/netplan/50-cloud-init.yml`

    - `/etc/cloud/cloud.cfg.d/99-disable-network-config.cfg`

    => see more netplan config
  
2. change host name `/etc/hostname` see netplan config

3. change hosts `/etc/hosts` see netplan config



`script.sh`
```bash
```

### Utility package

```bash
# see all stat memory, distributor, kernel, VM etc
sudo apt-get update
sudo apt-get install -y inxi neofetch

neofetch
inxi --system --machine --cpu --network --disk --info
```


### hosts config

```bash
# /etc/hosts

10.100.0.104    master.example.com  master
10.100.0.101    node1.example.com   node1
10.100.0.102    node2.example.com   node2

```


### VirtualBox config

- Idem host config and put port 22

- Define nat network(k8s Network): `10.100.0.0/24`

- Then set vm network config

- But I don't know if it's necessary. (at this moment network between vm is done using ssh by default)

### Docker


1. install

  ```bash

  # Add Docker's official GPG key:
  sudo apt-get update
  sudo apt-get install ca-certificates curl
  sudo install -m 0755 -d /etc/apt/keyrings

  # maybe copy next line(because package is already installed by vagrant)
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc

  # Add the repository to Apt sources:
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update

   sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

  ```

2. config to avoid sudo for docker action


  ```bash
  sudo groupadd docker # create docker group(normally, it exists already when install docker)

  sudo usermod -aG docker $USER # add current user in docker Group

  newgrp docker # apply changed group

  docker run hello-world # verify if it's applied
  
  ```

### K8S Commands

1. nodes status

```bash
kubectl get nodes
```


2. pods status

```bash
# all pods
kubectl get pods -A

# define name space to see
kubectl get pods -n kube-system
```


### Ref.

- [Vagrant + QEMU in Mac silicon](https://joachim8675309.medium.com/vagrant-with-macbook-mx-arm64-0f590fd7e48a)