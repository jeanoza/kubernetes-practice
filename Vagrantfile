Vagrant.configure("2") do |config|
  config.vm.box = "perk/ubuntu-2204-arm64"
  config.vm.hostname = "k8s-master"
  config.vm.network "private_network", ip: "10.100.0.104", netmask: "255.255.255.0"
  config.vm.network "public_network"
  # config.vm.network "forwarded_port", guest: 22, host: 4242, id: "ssh"
  config.vm.provider "qemu" do |qe|
    qe.ssh_port = "4242" # change ssh port as needed
    qe.memory = "2G"
    qe.cpus = 2
  end
end

# Vagrant.configure("2") do |config|
#   config.vm.network "private_network", ip: "10.100.0.10", netmask: "255.255.255.0"
#   config.vm.provider "qemu" do |q, provider|
#     provider.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
#   end
# end
