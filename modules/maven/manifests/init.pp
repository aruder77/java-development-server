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
  }
  
  file {
	"/opt/apache-maven-3.0.5":
		ensure 	=> directory,
		owner 	=> "root",
		group 	=> "root",
		require => [EXEC["untarMaven"]]; 
	"/opt/maven":
		ensure => link,
		target => "/opt/apache-maven-3.0.5",
		require => EXEC["untarMaven"];  
	"/opt/apache-maven-3.0.5/conf/settings.xml":
		require	=> EXEC["untarMaven"],
		source	=> "puppet:///modules/maven/settings.xml";
	"/opt/apache-maven-3.0.5/conf/settings-security.xml":
		require	=> EXEC["untarMaven"],
		source	=> "puppet:///modules/maven/settings-security.xml";
  }
}
