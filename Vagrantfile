# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.

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
  # dcsg.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"
    #dcsg.vm.synced_folder "../dcsg", "/opt/shotgun", force_user: "shotgun", force_group: "shotgun"
    sg_in_vagrant.vm.provision "file", source: "./script", destination: "$HOME/script"
    sg_in_vagrant.vm.provision "shell", path: "./script/setup_vagrant.sh", privileged: true
    #VAGRANT_COMMAND = ARGV[0]
    #if VAGRANT_COMMAND == "ssh"
    #  sg_in_vagrant.ssh.username = 'shotgun'
    #end
  end
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL
end
