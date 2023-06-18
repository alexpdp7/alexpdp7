class backups($sanoid_config) {
  package {'sanoid':}

  file {'/etc/sanoid':
    ensure => directory,
  }
  ->
  file {'/etc/sanoid/sanoid.conf':
    content => $sanoid_config,
  }
}
