node smoketest {
  include oracle::server
  include oracle::swap
  include oracle::xe
  include lxde::lxde
  include jdk::jdk
  include glassfish::glassfish
  include maven::maven
  include smoketest::smoketest
  
  package {
    ["bc", "unzip", "rlwrap", "dos2unix"]:
      ensure => installed;
  }

  group { "users":
    ensure	=> present;
  }
  
  user { "vagrant":
    groups => ["users"],
    require => GROUP["users"];
  }  
}
