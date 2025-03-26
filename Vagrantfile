DEFAULT_IP = "192.168.56"
MASTER_IP = "#{DEFAULT_IP}.104"
NODE_COUNT = 2
MEMORY = 2048
CPUS = 2

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"
  config.vbguest.auto_update = false

  # define worker ips
  worker_ips = (1..NODE_COUNT).map { |i| "#{DEFAULT_IP}.#{100 + i}" }

  config.vm.define "master" do |master|
    master.vm.hostname = "master"
    master.vm.network "private_network", ip: MASTER_IP
    master.vm.provider "virtualbox" do |vb|
      vb.name = "k8s-master"
      vb.memory = MEMORY
      vb.cpus = CPUS
    end
    master.vm.provision "shell", path: "./scripts/master.sh", args: [MASTER_IP, *worker_ips]
  end

  # create worker nodes dynamically
  (1..NODE_COUNT).each do |i|
    config.vm.define "node#{i}" do |node|
      node.vm.hostname = "node#{i}"
      node.vm.network "private_network", ip: worker_ips[i-1]
      node.vm.provider "virtualbox" do |vb|
        vb.name = "k8s-node#{i}"
        vb.memory = MEMORY
        vb.cpus = CPUS
      end
      node.vm.provision "shell", path: "./scripts/node.sh", args: [MASTER_IP]
    end
  end
end