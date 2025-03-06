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


### netplan config

- Attention: Don't touch `/etc/netplan/50-cloud-init.yaml` generated on install ubuntu

- disable default network config

```bash
# /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg

network: {config: disabled}
```

- new config

```bash
# /etc/netplan/01-netcfg.yaml
network:
  version: 2
  ethernets:
    eth0:
      dhcp4: no # put static
      addresses: [10.100.0.104/24]
      routes:
        - to: 0.0.0.0/0
          via: 10.100.0.1
      nameservers:
        addresses: [10.100.0.1] #dns
```

- test using ping

```bash
ping -c 4 www.google.com
# or
ping -c 4 8.8.8.8 

```

### hosts config

```bash
# /etc/hosts

10.100.0.104    master.example.com  master
10.100.0.101    node1.example.com   node1
10.100.0.102    node2.example.com   node2

```

### Ref.

- [Vagrant + QEMU in Mac silicon](https://joachim8675309.medium.com/vagrant-with-macbook-mx-arm64-0f590fd7e48a)