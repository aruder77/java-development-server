# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  config.vm.box = "trusty32"
  config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/trusty/trusty-server-cloudimg-i386-juju-vagrant-disk1.box"
  config.vm.hostname = "smoketest32"

  # Forward Oracle port
  config.vm.network :forwarded_port, guest: 1521, host: 1521
  config.vm.network :forwarded_port, guest: 5900, host: 5900
  config.vm.network :forwarded_port, guest: 22,   host: 22
  
  config.vm.synced_folder "X:/shared", "/sharedFolder"

  # Provider-specific configuration so you can fine-tune various backing
  # providers for Vagrant. These expose provider-specific options.
  config.vm.provider :virtualbox do |vb|
    # Use VBoxManage to customize the VM
	vb.gui = true
    vb.customize ["modifyvm", :id,
                  "--name", "smoketest",
				  "--cpus", "1",
                  "--memory", "1024",
				  "--vram", "64",
				  "--accelerate3d", "off",
				  "--clipboard", "bidirectional",
				  "--draganddrop", "bidirectional",
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
    puppet.options = ""
  end
end
