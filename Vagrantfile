DEFAULT_IP = "192.168.56"
MASTER_IP = "#{DEFAULT_IP}.104"
NODE1_IP = "#{DEFAULT_IP}.101"
NODE2_IP = "#{DEFAULT_IP}.102"

MASTER_HOSTNAME = "master"
NODE1_HOSTNAME = "node1"
NODE2_HOSTNAME = "node2"

MEMORY = 2048
CPUS = 2

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"
  config.vbguest.auto_update = false

  config.vm.define MASTER_HOSTNAME do |master|
    master.vm.hostname = MASTER_HOSTNAME

    master.vm.provider "virtualbox" do |vb|
      vb.name = "k8s-#{MASTER_HOSTNAME}"
      vb.cpus = CPUS
      vb.memory = MEMORY
    end

    master.vm.network "private_network", ip: MASTER_IP


    # exec master.sh
    master.vm.provision "shell", path: "./scripts/master.sh", args: [MASTER_IP, NODE1_IP, NODE2_IP]
  end

  config.vm.define NODE1_HOSTNAME do |node1|
    node1.vm.hostname = NODE1_HOSTNAME

    node1.vm.provider "virtualbox" do |vb|
      vb.name = "k8s-#{NODE1_HOSTNAME}"
      vb.cpus = CPUS
      vb.memory = MEMORY
    end

    node1.vm.network "private_network", ip: NODE1_IP
    # exec node.sh
    node1.vm.provision "shell", path: "./scripts/node.sh", args: [MASTER_IP]
  end 

  config.vm.define NODE2_HOSTNAME do |node2|
    node2.vm.hostname = NODE2_HOSTNAME

    node2.vm.provider "virtualbox" do |vb|
      vb.name = "k8s-#{NODE2_HOSTNAME}"
      vb.cpus = CPUS
      vb.memory = MEMORY
    end

    node2.vm.network "private_network", ip: NODE2_IP
    # exec node.sh
    node2.vm.provision "shell", path: "./scripts/node.sh", args: [MASTER_IP]
  end 
end
