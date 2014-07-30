class glassfish::glassfish {
  require oracle::server
  
  exec {
	"downloadGlassfish":
		cwd		=> "/opt",
		command => "/usr/bin/wget -q --no-proxy --user=bne3_dev --password=dev4bne3 http://libne3ci01.bmwgroup.net:11000/nexus/content/repositories/bne3_thirdparty/com/oracle/glassfish/3.1.2.8/glassfish-3.1.2.8-bin.zip -O /opt/glassfish.zip",
		creates	=> "/opt/glassfish.zip";	
	"unzipGlassfish":
		cwd 	=> "/opt",
		command => "/usr/bin/unzip glassfish.zip",
		require => [FILE["/opt/glassfish.zip"],PACKAGE["unzip"]];
  }
  
   user {
    "glassfish":
      ensure => present,
	  password => '$6$yRBJ9M4l$e23UAIbmLbr4hF.ObV05U2qG/TxaywfPk3Z.MmGj0bHxoe37AVyMQ3iifQpIxjveQAKqyYK9puxXEDW4xmUNM0',
	  gid	 => "glassfish",
      groups => ["users"],
	  managehome => true,
	  shell	 => "/bin/bash",
	  require => [Group["users"], Group["glassfish"]];
  }
  
  group {
    "glassfish":
		ensure	=> present;
  }

  file {
	"/opt/glassfish.zip":
		require => EXEC["downloadGlassfish"];
	"/opt/glassfish":
		ensure 	=> directory,
		owner 	=> "glassfish",
		group 	=> "glassfish",
		recurse => true,
		mode	=> "g+rw",
		require => [EXEC["unzipGlassfish"],USER["glassfish"]];  
  }
}
