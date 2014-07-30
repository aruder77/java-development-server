class jdk::jdk {
  file {
    "/opt/jdk-7u51-linux-x64.gz":
      source => "puppet:///modules/jdk/jdk-7u51-linux-x64.gz";
  }
  
  exec {
	"untarJdk":
		cwd 	=> "/opt",
		command => "/bin/tar xzf jdk-7u51-linux-x64.gz",
		require => FILE["/opt/jdk-7u51-linux-x64.gz"];
  }
  
  file {
	"/opt/jdk1.7.0_51":
		ensure 	=> directory,
		owner 	=> "root",
		group 	=> "root",
		require => EXEC["untarJdk"];
  
	"/opt/java":
		ensure => link,
		target => "/opt/jdk1.7.0_51",
		require => EXEC["untarJdk"];
  }
}
