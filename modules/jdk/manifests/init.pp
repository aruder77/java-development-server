class jdk::jdk {
  exec {
	"downloadJdk":
		cwd		=> "/opt",
		command => "/usr/bin/wget -q --no-proxy --user=bne3_dev --password=dev4bne3 http://libne3ci01.bmwgroup.net:11000/nexus/content/repositories/bne3_thirdparty/com/oracle/java/jdk/jdk-linux/1.7.0.55/jdk-linux-1.7.0.55-x64.zip -O /opt/jdk.zip",
		creates	=> "/opt/jdk.zip";
  
	"unzipJdk":
		cwd 	=> "/opt/jdk",
		command => "/usr/bin/unzip /opt/jdk.zip",
		require => [FILE["/opt/jdk.zip"], FILE["/opt/jdk"]];
  }
  
  file {
	"/opt/jdk.zip":
		require => EXEC["downloadJdk"];
	"/opt/jdk":
		ensure 	=> directory,
		owner 	=> "root",
		group 	=> "root";
	"/opt/java":
		ensure => link,
		target => "/opt/jdk",
		require => EXEC["unzipJdk"];
	"/opt/jdk/bin":
		recurse => true,
		mode	=> "0775",
		require => EXEC["unzipJdk"];
  }
}
