class oracle::server {
  exec { "apt-update":
    command => "/usr/bin/apt-get -y update",
    timeout => 3600;
  }

  package {
    ["alien", "libaio1", "unixodbc"]:
      ensure => installed;
  }

  exec { "procps":
    refreshonly => true,
    command => "/etc/init.d/procps start";
  }

  file {
    "/tmp/chkconfig":
      mode => 0755,
      source => "puppet:///modules/oracle/chkconfig";
    "/tmp/60-oracle.conf":
      notify => Exec['procps'],
      source => "puppet:///modules/oracle/60-oracle.conf";
    "/tmp/S01shm_load":
      mode => 0755,
      source => "puppet:///modules/oracle/S01shm_load";
  }

  # If we're running on Windows, then Git may have converted line endings to CRLF upon cloning the
  # repository. Here we use dos2unix to make sure that they are LF.
  exec {
    "dos2unix chkconfig":
      command => "/usr/bin/dos2unix -n /tmp/chkconfig /sbin/chkconfig",
      creates => "/sbin/chkconfig",
      require => [File["/tmp/chkconfig"], Package["dos2unix"]];
    "dos2unix 60-oracle.conf":
      command => "/usr/bin/dos2unix -n /tmp/60-oracle.conf /etc/sysctl.d/60-oracle.conf",
      creates => "/etc/sysctl.d/60-oracle.conf",
      require => [File["/tmp/60-oracle.conf"], Package["dos2unix"]];
    "dos2unix S01shm_load":
      command => "/usr/bin/dos2unix -n /tmp/S01shm_load /etc/rc2.d/S01shm_load",
      creates => "/etc/rc2.d/S01shm_load",
      require => [File["/tmp/S01shm_load"], Package["dos2unix"]];
  }

  user {
    "syslog":
      ensure => present,
      groups => ["syslog", "adm"];
  }
  
  user { "oracle":
    ensure	=> present,
    groups 	=> ["users", "dba"],
	password => '$6$XKass0/1$pqZNF0ksYRUkJff4TOdBRFYtkfBAJ7ml3.cMcm7gxrbm9Mn5eE7OWlA/e4wM41RDnWuZp/o5V4fS70K1/gTVN/',
    managehome => true,
	shell	 => "/bin/bash",
    # So that we let Oracle installer create the group
    require => [GROUP["users"], Service["oracle-xe"]];
  }  

  group {
    "puppet":
      ensure => present;
  }

  exec { "set up shm":
    command => "/etc/rc2.d/S01shm_load start",
    require => Exec["dos2unix S01shm_load"],
    user => root,
    unless => "/bin/mount | grep /dev/shm 2>/dev/null";
  }

  Exec["apt-update"] -> Package <| |>
}

class oracle::swap {
  exec {
    "create swapfile":
      # Needs to be 2 times the memory
      command => "/bin/dd if=/dev/zero of=/swapfile bs=1M count=1024",
      user => root,
      creates => "/swapfile";
    "set up swapfile":
      command => "/sbin/mkswap /swapfile",
      require => Exec["create swapfile"],
      user => root,
      unless => "/usr/bin/file /swapfile | grep 'swap file' 2>/dev/null";
    "enable swapfile":
      command => "/sbin/swapon /swapfile",
      require => Exec["set up swapfile"],
      user => root,
      unless => "/bin/cat /proc/swaps | grep '^/swapfile' 2>/dev/null";
    "add swapfile entry to fstab":
      command => "/bin/echo >>/etc/fstab /swapfile swap swap defaults 0 0",
      user => root,
      unless => "/bin/grep '^/swapfile' /etc/fstab 2>/dev/null";
  }

  file {
    "/swapfile":
      mode => 600,
      owner => root,
      group => root,
      require => Exec['create swapfile'];
  }
}

class oracle::sqldeveloper {
  file {
	"/opt/sqldeveloper.zip":
	  source => "puppet:///modules/oracle/sqldeveloper.zip";	
	"/opt/sqldeveloper":
	  owner		=> oracle,
	  group		=> dba,
	  mode		=> "g+rw",
	  require	=> EXEC["unzipSqlDeveloper"];
	"/opt/sqldeveloper/sqldeveloper.sh":
	  mode		=> "+x",
	  require	=> EXEC["unzipSqlDeveloper"];
	"/opt/sqldeveloper/ide/bin/launcher.sh":
	  mode		=> "+x",
	  require	=> EXEC["unzipSqlDeveloper"];
  }
  
  exec {
    "unzipSqlDeveloper":
	  cwd	=> "/opt",
	  command => "/usr/bin/unzip /opt/sqldeveloper.zip",
	  require => [File["/opt/sqldeveloper.zip"],Package["unzip"]];
  }
}

class oracle::xe {
  file {
	"/home/vagrant/oracle-xe.rpm.zip":
	  require	=> EXEC["downloadOracle"];
    "/tmp/oracle-env.sh":
      source => "puppet:///modules/oracle/oracle-env.sh";
    "/tmp/xe.rsp.orig":
      source => "puppet:///modules/oracle/xe.rsp";
    "/bin/awk":
      ensure => link,
      target => "/usr/bin/awk";
    "/var/lock/subsys":
      ensure => directory;
    "/var/lock/subsys/listener":
      ensure => present;
  }

  exec {
	"downloadOracle":
		cwd		=> "/tmp",
		command => "/usr/bin/wget -q --no-proxy --user=bne3_dev --password=dev4bne3 http://XXX/oracle-xe-11.2.0-1.0-x86_64.zip -O /home/vagrant/oracle-xe.rpm.zip",
		creates	=> "/home/vagrant/oracle-xe.rpm.zip";
    "dos2unix oracle-env.sh":
      command => "/usr/bin/dos2unix -n /tmp/oracle-env.sh /etc/profile.d/oracle-env.sh",
      creates => "/etc/profile.d/oracle-env.sh",
      require => [File["/tmp/oracle-env.sh"], Package["dos2unix"]];
    "dos2unix xe.rsp":
      command => "/usr/bin/dos2unix -n /tmp/xe.rsp.orig /tmp/xe.rsp",
      creates => "/tmp/xe.rsp",
      require => [File["/tmp/xe.rsp.orig"], Package["dos2unix"]];
  }

  exec {
    "unzip xe":
      command => "/usr/bin/unzip -o oracle-xe.rpm.zip",
      require => [Package["unzip"], File["/home/vagrant/oracle-xe.rpm.zip"]],
      cwd => "/home/vagrant",
      user => root,
      creates => "/home/vagrant/oracle-xe-11.2.0-1.0.x86_64.rpm",
      timeout => 3600,
      unless => "/usr/bin/test -f /etc/default/oracle-xe";
    "alien xe":
      command => "/usr/bin/alien --to-deb --scripts Disk1/oracle-xe-11.2.0-1.0.x86_64.rpm",
      cwd => "/home/vagrant",
      require => [Package["alien"], Exec["unzip xe"]],
      creates => "/home/vagrant/oracle-xe_11.2.0-2_amd64.deb",
      user => root,
      timeout => 3600,
      unless => "/usr/bin/test -f /etc/default/oracle-xe";
    "configure xe":
      command => "/etc/init.d/oracle-xe configure responseFile=/tmp/xe.rsp >> /tmp/xe-install.log",
      timeout => 3600,
      require => [Package["oracle-xe"],
                  Exec["dos2unix oracle-env.sh"],
                  Exec["dos2unix xe.rsp"],
                  File["/var/lock/subsys/listener"],
                  Exec["set up shm"],
                  Exec["enable swapfile"]],
      creates => "/etc/default/oracle-xe";
  }

  package {
    "oracle-xe":
      provider => "dpkg",
      ensure => latest,
      require => [Exec["alien xe"]],
      source => "/home/vagrant/oracle-xe_11.2.0-2_amd64.deb",
  }

  exec {
    "run chkconfig":
      command => "/sbin/chkconfig",
      user => root,
      require => Service["oracle-xe"];
  }

  service {
    "oracle-xe":
      ensure => "running",
	  enable => true,
      require => [Package["oracle-xe"],
                  Exec["configure xe"],
                  Exec["dos2unix chkconfig"],
                  Exec["dos2unix 60-oracle.conf"]],
  }
}
