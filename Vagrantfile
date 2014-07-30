# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  config.vm.box = "quantal64"
  config.vm.box_url = "https://github.com/downloads/roderik/VagrantQuantal64Box/quantal64.box"
  config.vm.hostname = "smoketest"

  # Forward Oracle port
  config.vm.network :forwarded_port, guest: 1521, host: 1521
  config.vm.network :forwarded_port, guest: 5900, host: 5900
  config.vm.network :forwarded_port, guest: 22,   host: 22
  
  config.vm.synced_folder "shared", "/shared"

  # Provider-specific configuration so you can fine-tune various backing
  # providers for Vagrant. These expose provider-specific options.
  config.vm.provider :virtualbox do |vb|
    # Use VBoxManage to customize the VM
	vb.gui = true
    vb.customize ["modifyvm", :id,
                  "--name", "smoketest",
                  "--memory", "1024",
				  "--vram", "64",
				  "--accelerate3d", "on",
                  # Enable DNS behind NAT
                  "--natdnshostresolver1", "on"]
  end

  config.vm.provision :shell, :inline => "echo \"Europe/Berlin\" | sudo tee /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata"
  # config.vm.provision :shell, :inline => "sudo update-locale LANG=de_DE.UTF-8"

  config.vbguest.auto_update = false

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "manifests"
    puppet.module_path = "modules"
    puppet.manifest_file = "base.pp"
    puppet.options = "--verbose --trace"
  end
end
