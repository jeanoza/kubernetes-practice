 This is a sandbox environment. Using personal credentials is HIGHLY! discouraged. Any consequences of doing so, are completely the user's responsibilites.
 You can bootstrap a cluster as follows:

 1. Initializes cluster master node:

 kubeadm init --apiserver-advertise-address $(hostname -i) --pod-network-cidr 10.5.0.0/16


 2. Initialize cluster networking:

 kubectl apply -f https://raw.githubusercontent.com/cloudnativelabs/kube-router/master/daemonset/kubeadm-kuberouter.yaml


 3. (Optional) Create an nginx deployment:

 kubectl apply -f https://raw.githubusercontent.com/kubernetes/website/master/content/en/examples/application/nginx-app.yaml


Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 192.168.0.18:6443 --token saqjs6.3a62d5y88zk2zb9p \
        --discovery-token-ca-cert-hash sha256:1bd380a67f396d845b81151b3f34384305d143aaad1f66c8bbb430044f0fe0f5 