# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  # Box
  config.vm.box = "ubuntu/trusty64"

  # Box Configurations - more power!
  config.vm.provider :virtualbox do |v|
    v.customize ["modifyvm", :id, "--memory", 2048]
    v.customize ["modifyvm", :id, "--cpus", 2]
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end

  # SSH Agent Forwarding
  config.ssh.forward_agent = true

  # Hostnames
  config.vm.hostname = "www.example.org"
  config.hostsupdater.aliases = ["lamp.example.org"]

  # Private Network
  config.vm.network :private_network, ip: "192.168.13.37"

  config.vm.synced_folder "www", "/var/www", :owner => "www-data", :mount_options => [ "dmode=775", "fmode=774" ]

  # Provisioning
  config.vm.provision "provisioning", type: "shell", :path => "provision.sh", args: [
    "pass@word1", # MySQL password,
    "example.org", # Server name
    "lamp.example.org", # Server alias
    "webmaster@example.org" # Server admin
  ]

  config.vm.provision "no-tty-fix", type: "shell", inline: "sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile"
end
