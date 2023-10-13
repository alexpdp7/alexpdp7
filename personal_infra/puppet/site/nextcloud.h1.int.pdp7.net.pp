node 'nextcloud.h1.int.pdp7.net' {
  class {'nextcloud':
    database_name => 'nextcloud',
    database_user => 'nextcloud',
    database_host => 'pg.h1.int.pdp7.net',
  }

  file {'/var/lib/nextcloud/apps':
    ensure => 'link',
    target => '/nextcloud/apps/',
  }

  file {'/var/lib/nextcloud/data':
    ensure => 'link',
    target => '/nextcloud/data/',
  }

  file {'/etc/nextcloud/config.php':
    ensure => 'link',
    target => '/nextcloud/config.php',
  }
}
