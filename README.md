### TODO list

- Master VM


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

192.168.56.104    master.example.com  master
192.168.56.101    node1.example.com   node1
192.168.56.102    node2.example.com   node2

```


### K8S Commands

#### kubectl

```bash
kubectl [command] [type] [name] [flag]
```

```bash
kubectl api-resources # show all shortcut and description of object type

kubectl --help
```

- command

1. get
```bash
# all nodes
kubectl get nodes
# all pods
kubectl get pods -A
# define name space to see
kubectl get pods -n kube-system
```

2. `create`

3. `delete`

4. `edit`

5. `describe`
```bash
kubectl describe node master
```

- type
    - node
    - pod
    - service

- name: name of `type`

- flag



### Ref.

- [Vagrant + QEMU in Mac silicon](https://joachim8675309.medium.com/vagrant-with-macbook-mx-arm64-0f590fd7e48a)