class filer {

  package {"samba":}

  file {"/etc/samba/smb.conf":
    content => template("filer/smb.conf"),
    notify => [
      Service["smbd"],
      Service["nmbd"],
    ],
    require => Package["samba"],
  }

  service {"smbd":
    ensure => running,
    enable => true,
  }

  service {"nmbd":
    ensure => running,
    enable => true,
  }
}
