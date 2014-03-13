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
	"addGlassfishToPath":
		command	=> "/bin/echo 'PATH=\$PATH:/opt/glassfish3/glassfish/bin' >> /home/vagrant/.profile",
		require	=> USER["vagrant"];
  }
  
  file {
	"/opt/glassfish3":
		ensure 	=> directory,
		owner 	=> "vagrant",
		group 	=> "vagrant",
		require => [EXEC["unzipGlassfish"],USER["vagrant"]];  
  }
}
