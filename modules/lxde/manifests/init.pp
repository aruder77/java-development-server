class lxde::lxde {
  package {
    ["lxde", "language-pack-de", "x11vnc", "virtualbox-guest-utils", "virtualbox-guest-x11", "virtualbox-guest-dkms"]:
      ensure => installed;
  }  
  
   exec {
	"fixShotdownFromLxdeProblem":
		command	=> "/bin/echo 'session required pam_systemd.so' >> /etc/pam.d/lxdm",
		require	=> PACKAGE["lxde"];
   }
}
