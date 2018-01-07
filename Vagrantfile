
Vagrant.configure("2") do |config|
  # config.vm.box_check_update = false

  config.vm.define :sg_in_vagrant do |sg_in_vagrant|
    sg_in_vagrant.vm.provider "virtualbox" do |v|
          v.customize ["modifyvm", :id, "--name", "shotgun_in_vagrant", "--memory", "2048"]
    end
    sg_in_vagrant.vm.box = "geerlingguy/centos7"
    sg_in_vagrant.vm.hostname = "shotgun"
    sg_in_vagrant.vm.network "public_network", bridge: 'en0: Wi-Fi (AirPort)', ip: "192.168.0.10" 
    sg_in_vagrant.vm.network "forwarded_port", guest: 80, host: 8888
    sg_in_vagrant.vm.network "forwarded_port", guest: 8080, host: 9999
    sg_in_vagrant.vm.provision "file", source: "./script", destination: "$HOME/script"
    sg_in_vagrant.vm.provision "shell", path: "./script/setup_vagrant.sh", privileged: true
  end
end
