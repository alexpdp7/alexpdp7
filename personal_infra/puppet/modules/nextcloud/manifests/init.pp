class nextcloud(
  $database_name,
  $database_user,
  $database_host,
) {

    package {['nextcloud-httpd', 'nextcloud-postgresql']:}

    service {'httpd':
        enable => true,
        ensure => running,
        subscribe => Package['nextcloud-httpd'],
    }

    service {'nextcloud-cron.timer':
        ensure => running,
        enable => true,
        require => Package['nextcloud-httpd'],
    }

    file {'/etc/php-fpm.d/www.conf':
        content => epp("nextcloud/www.conf", {}),
    }
    ~>
    service {'php-fpm':
        enable => true,
        ensure => running,
        subscribe => Package['nextcloud-httpd'],
    }

    file {'/etc/httpd/conf.d/z-nextcloud-access.conf':
        ensure => '/etc/httpd/conf.d/nextcloud-access.conf.avail',
        require => Package['nextcloud-httpd'],
        notify => Service['httpd'],
    }

    package {['php-intl', 'php-bcmath']:}

    file {'/etc/php.d/99-apcu-cli.ini':
      content => @("EOT")
      apc.enable_cli=1
      | EOT
      ,
    }

    cron {"nextcloud-previews":
      command => "cd /tmp/ ; sudo -u apache php -d memory_limit=512M /usr/share/nextcloud/occ preview:generate-all -q",
      minute => "41",
    }
}
