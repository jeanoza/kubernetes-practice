Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"
  config.vbguest.auto_update = false
  username = `whoami`.strip

  config.vm.define "k8s-master" do |master|
    master.vm.hostname = "master.example.com"

    master.vm.provider "virtualbox" do |vb|
      vb.name = "k8s-master"
      vb.cpus = 2
      vb.memory = 2048
    end
  end
end
