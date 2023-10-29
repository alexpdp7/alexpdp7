class remote_desktop {
  package {['xorgxrdp', 'xrdp']:}

  file {'/etc/xrdp/xrdp.ini':
    content => template('remote_desktop/xrdp.ini'),
    require => Package['xrdp'],
  }
  ~>
  service {'xrdp':
    enable => true,
    ensure => running,
  }

  exec {'/usr/bin/dnf group install -y GNOME':
    unless => '/usr/bin/dnf grouplist -v hidden --installed | grep GNOME',
    timeout => 0,
  }
}
