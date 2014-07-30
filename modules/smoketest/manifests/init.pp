class smoketest::smoketest {
  require oracle::sqldeveloper

  package {
    ["libav-tools", "libavcodec-extra", "git"]:
      ensure => installed;
  }
  
  user { "smoketest":
      ensure => present,
	  password => '$6$B75PJWzn$kC3w1dsQBDCxPn3ueGHerAk80L4F39FMBISmV/z7CeXy2xctxF1Q796VN0iHvVB39uQT85IBpyQz0rthE/tWq1',
      groups => ["users", "glassfish", "adm", "sudo", "dip", "plugdev", "lpadmin", "sambashare", "dba", "vboxsf"],
	  shell	 => "/bin/bash",
	  managehome => true,
	  require => [Group["users"], GROUP["glassfish"]];
  }  
  
  user { "jenkins":
      ensure => present,
	  password => '$6$5.sZO8av$YGlg.bvTeCyCTuVPsCMi1HPG9DtIV1T7RSw1WMEcnmCtEQ9OgrjpJNwd6CcryMLvTC/u1KxrXZwE5h2DwoM4L/',
      groups => ["users", "glassfish"],
	  shell	 => "/bin/bash",
	  managehome => true,
	  require => [Group["users"], GROUP["glassfish"]];
  }  
  
  user { "ubuntu":
      ensure => present,
	  password => '$6$DoxKAp.3$zcoDZS2p6C2U4ULmk4oYyycVmVgPvjYcwXZYPT810EPDZtzNmVSdCuz5ajS.Zc9vcchw5Ikvuz7Ksz3NikRD3/',
      groups => ["users", "glassfish"],
	  shell	 => "/bin/bash",
	  managehome => true,
	  require => [Group["users"], GROUP["glassfish"]];
  }  
  
  exec {
	"addGlassfishToSmoketestPath":
		command	=> "/bin/echo 'PATH=\$PATH:/opt/glassfish/bin' >> /home/smoketest/.profile",
		require	=> USER["smoketest"];
	"addJavaToSmoketestPath":
		command	=> "/bin/echo 'PATH=\$PATH:/opt/java/bin' >> /home/smoketest/.profile",
		require	=> USER["smoketest"];
	"addMavenToSmoketestPath":
		command	=> "/bin/echo 'PATH=\$PATH:/opt/maven/bin' >> /home/smoketest/.profile",
		require	=> USER["smoketest"];
	"addGlassfishToJenkinsPath":
		command	=> "/bin/echo 'PATH=\$PATH:/opt/glassfish/bin' >> /home/jenkins/.profile",
		require	=> USER["jenkins"];
	"addJavaToJenkinsPath":
		command	=> "/bin/echo 'PATH=\$PATH:/opt/java/bin' >> /home/jenkins/.profile",
		require	=> USER["jenkins"];
	"addMavenToJenkinsPath":
		command	=> "/bin/echo 'PATH=\$PATH:/opt/maven/bin' >> /home/jenkins/.profile",
		require	=> USER["jenkins"];
	"enableLxdeShutdown":
	    command	=> "/bin/echo 'session optional   pam_loginuid.so' >> /etc/pam.d/common-session",
		require => PACKAGE["lxde"];
  }

  file {
    "/usr/local/bin/":
	  recurse => true,
	  owner   => 'root',
	  group   => 'root',
	  mode    => '0755',
      source => "puppet:///modules/smoketest/localBin";
    "/home/smoketest/.m2":
	  ensure  => directory,
	  recurse => true,
	  owner   => 'smoketest',
	  group   => 'smoketest',
	  mode    => '0644',
      source => "puppet:///modules/smoketest/m2Settings";
    "/home/jenkins/.m2":
	  ensure  => directory,
	  recurse => true,
	  owner   => 'jenkins',
	  group   => 'users',
	  mode    => '0644',
      source => "puppet:///modules/smoketest/m2Settings";
	"/opt/glassfish/password.txt":
	  require => EXEC["unzipGlassfish"],
	  source => "puppet:///modules/smoketest/password.txt";
	"/media/sf_":
		ensure => directory,
		owner  => root,
		group  => vboxsf,
		mode   => 0775;
	"/shared":
		ensure => link,
		target => "/media/sf_/sharedFolder";
  }
  
  	$autostart_dirs = [ "/home/smoketest/.config/", "/home/smoketest/.config/autostart/"]

	file { $autostart_dirs:
		ensure => "directory",
		owner  => "smoketest",
		group  => "smoketest",
		mode   => 750,
		require => USER["smoketest"];
	}
	
  file {
    "/etc/lxdm/PostLogin":
      mode => 0755,
	  require => PACKAGE["lxde"],
      source => "puppet:///modules/smoketest/PostLogin";
    "/home/smoketest/.config/autostart/auto.desktop":
      mode => 0664,
      source => "puppet:///modules/smoketest/auto.desktop",
	  require => USER["smoketest"];
    "/home/smoketest/.config/autostart/autostart.sh":
	  mode => 0775,
	  source => "puppet:///modules/smoketest/autostart.sh",
	  require => USER["smoketest"];
    "/home/smoketest/.xscreensaver":
      mode => 0664,
      source => "puppet:///modules/smoketest/.xscreensaver",
	  require => USER["smoketest"];
    "/etc/lxdm/lxdm.conf":
      mode => 0644,
	  owner => "root",
	  group => "root",
      source => "puppet:///modules/smoketest/lxdm.conf",
	  require => PACKAGE["lxde"];
	"/home/smoketest/Desktop":
	  ensure	=> directory,
	  owner		=> smoketest,
	  group		=> users,
  	  require 	=> USER["smoketest"];
    "/home/smoketest/Desktop/README.html":
	  mode => 0664,
	  owner	=> smoketest,
	  group => users,
	  source => "puppet:///modules/smoketest/README.html",
  	  require => File["/home/smoketest/Desktop"];
    "/home/smoketest/Desktop/sqldeveloper.sh":
	  mode => 07754,
	  owner	=> smoketest,
	  group => users,
	  source => "puppet:///modules/smoketest/sqldeveloper.sh",
  	  require => File["/home/smoketest/Desktop"];
  }
  
  exec {
    "startLxdm":
		command => "/etc/init.d/lxdm start",
		require => [FILE["/etc/lxdm/lxdm.conf"],FILE["/home/smoketest/.xscreensaver"], FILE["/home/smoketest/.config/autostart/auto.desktop"],FILE["/home/smoketest/.config/autostart/autostart.sh"]];
  }
}
