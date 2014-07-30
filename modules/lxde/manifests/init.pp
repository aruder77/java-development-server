class lxde::lxde {
  package {
    ["lxde", "language-pack-de", "x11vnc"]:
      ensure => installed;
  }  
}
