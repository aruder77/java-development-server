class lxde::lxde {
  package {
    ["lxde", "language-pack-de", "x11vnc"]:
      ensure => installed;
  }
  
	$autostart_dirs = [ "/home/vagrant/.config/", "/home/vagrant/.config/autostart/"]

	file { $autostart_dirs:
		ensure => "directory",
		owner  => "vagrant",
		group  => "vagrant",
		mode   => 750,
		require => USER["vagrant"];
	}
	
  file {
    "/etc/lxdm/PostLogin":
      mode => 0755,
      source => "puppet:///modules/lxde/PostLogin";
    "/home/vagrant/.config/autostart/auto.desktop":
      mode => 0664,
      source => "puppet:///modules/lxde/auto.desktop",
	  require => USER["vagrant"];
    "/home/vagrant/.config/autostart/autostart.sh":
	  mode => 0775,
	  source => "puppet:///modules/lxde/autostart.sh",
	  require => USER["vagrant"];
    "/home/vagrant/.xscreensaver":
      mode => 0664,
      source => "puppet:///modules/lxde/.xscreensaver",
	  require => USER["vagrant"];
    "/etc/lxdm/lxdm.conf":
      mode => 0644,
	  owner => "root",
	  group => "root",
      source => "puppet:///modules/lxde/lxdm.conf",
	  require => PACKAGE["lxde"];
  }
  
  exec {
    "startLxdm":
		command => "/etc/init.d/lxdm start",
		require => [FILE["/etc/lxdm/lxdm.conf"],FILE["/home/vagrant/.xscreensaver"], FILE["/home/vagrant/.config/autostart/auto.desktop"],FILE["/home/vagrant/.config/autostart/autostart.sh"]];
  }
}
