class maven::maven {

  file {
    "/opt/apache-maven-3.0.5-bin.tar.gz":
      source => "puppet:///modules/maven/apache-maven-3.0.5-bin.tar.gz";
  }
  
  exec {
	"untarMaven":
		cwd 	=> "/opt",
		command => "/bin/tar xzf apache-maven-3.0.5-bin.tar.gz",
		require => FILE["/opt/apache-maven-3.0.5-bin.tar.gz"];
	"addMavenToPath":
		command	=> "/bin/echo 'PATH=\$PATH:/opt/apache-maven/bin' >> /home/vagrant/.profile",
		require	=> USER["vagrant"];
  }
  
  file {
	"/opt/apache-maven-3.0.5":
		ensure 	=> directory,
		owner 	=> "vagrant",
		group 	=> "vagrant",
		require => [EXEC["untarMaven"],USER["vagrant"]]; 
	"/opt/apache-maven":
		ensure => link,
		target => "/opt/apache-maven-3.0.5",
		require => EXEC["untarMaven"];  
  }
}
