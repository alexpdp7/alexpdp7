class nextcloud(
  $database_name,
  $database_user,
  $database_host,
  $admin_pass,
  $data_dir,
) {

    file {'/etc/yum.repos.d/koalillo-nextcloud-epel-9.repo':
      content => @("EOT"/$)
      [copr:copr.fedorainfracloud.org:koalillo:nextcloud-test]
      name=Copr repo for nextcloud owned by koalillo
      baseurl=https://download.copr.fedorainfracloud.org/results/koalillo/nextcloud-test/epel-9-\$basearch/
      type=rpm-md
      skip_if_unavailable=True
      gpgcheck=1
      gpgkey=https://download.copr.fedorainfracloud.org/results/koalillo/nextcloud-test/pubkey.gpg
      repo_gpgcheck=0
      enabled=1
      enabled_metadata=1
      | EOT
      ,
    }

    package {'remi-release':
        source => 'https://rpms.remirepo.net/enterprise/remi-release-9.rpm',
    }
    ->
    exec {'/usr/bin/dnf module enable -y php:remi-8.2':
        unless => '/usr/bin/dnf module list --enabled php | grep remi-8.2',
    }

    package {['nextcloud-httpd', 'nextcloud-postgresql', 'php82-php-pecl-apcu', 'php-sodium', 'php-opcache',]:
        require => [
           Exec['/usr/bin/dnf module enable -y php:remi-8.2'],
           File['/etc/yum.repos.d/koalillo-nextcloud-epel-9.repo'],
        ],
    }

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
      command => "sudo -u apache php -d memory_limit=512M /usr/share/nextcloud/occ preview:generate",
      minute => "41",
    }
}
