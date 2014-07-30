class glassfish::glassfish {

  file {
    "/opt/ogs-3.1.2.2.zip":
      source => "puppet:///modules/glassfish/ogs-3.1.2.2.zip";
  }
  
  exec {
	"unzipGlassfish":
		cwd 	=> "/opt",
		command => "/usr/bin/unzip ogs-3.1.2.2.zip",
		require => [FILE["/opt/ogs-3.1.2.2.zip"],PACKAGE["unzip"]];
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
	"/opt/glassfish3":
		ensure 	=> directory,
		owner 	=> "glassfish",
		group 	=> "glassfish",
		recurse => true,
		mode	=> "g+rw",
		require => [EXEC["unzipGlassfish"],USER["glassfish"]];  
	"/opt/glassfish3/glassfish/domains/domain1/config":
		ensure 	=> directory,
		mode	=> "g+x",
		require => FILE["/opt/glassfish3"];  
  }
}
