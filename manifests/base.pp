node oracle {
  include oracle::server
  include oracle::swap
  include oracle::xe
  include lxde::lxde
  include jdk::jdk
  include glassfish::glassfish
  include maven::maven
  include smoketest::smoketest

  user { "vagrant":
    groups => "dba",
    # So that we let Oracle installer create the group
    require => Service["oracle-xe"],
  }
}
