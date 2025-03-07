Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"
  config.vbguest.auto_update = false

  config.vm.define "k8s-master" do |master|
    master.vm.hostname = "k8s-master"

    master.vm.provider "virtualbox" do |vb|
      vb.name = "k8s-master"
      vb.cpus = 2
      vb.memory = 2048
    end

    # Network configuration (need or not?)
    # This is not work but i have ssh by default
    # master.vm.network "private_network", type: "dhcp", virtualbox__nat_network: "k8s Network"


    # exec setup.sh
    master.vm.provision "shell", path: "setup.sh"
  end
end
