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
kubectl <command> [type] [name] <flag>
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


```bash
# restart Weave
kubectl rollout restart daemonset -n kube-system weave-net

# log flannel pods
kubectl logs -n kube-flannel -l app=flannel
```

5. etc

```bash
# create a pod using nginx image to 80 port
kubectl run webserver --image=nginx:1.14 --port 80
kubectl run webserver --image=nginx:1.14 --port 80 --dry-run # verify if it's possible to create
kubectl run webserver --image=nginx:1.14 --port 80 --dry-run -o yaml #save as yaml (stdout)

# create a pod using yaml
kubectl create -f webserver-pod.yaml 

# create deploy 3 pods
kubectl create deployment mainui --image=httpd --replicas=3

# enter in to the pod(webserver)
kubectl exec webserver -it -- sh

# edit api active -> updating yaml
kubectl edit deployments.apps 

# delete
kubectl delete pod webserver
kubectl delete deployments.apps mainui

# config
kubectl config --help
kubectl config view
# create a context
kubectl config set-context blue@kubernetes --cluster=kubernetes --user=kubernetes-admin --namespace=blue
kubectl config use-context blue@kubernetes
```



### Ref.

- [Vagrant + QEMU in Mac silicon](https://joachim8675309.medium.com/vagrant-with-macbook-mx-arm64-0f590fd7e48a)