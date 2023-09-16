class ocserv($ocserv_tcp_port,
             $ocserv_udp_port,
             $ocserv_default_domain,
             $ocserv_ipv4_network,
             $ocserv_dns,
             $ocserv_split_dns,
             $ocserv_routes,
             $firewall = true)
{
  $run_as_user =  $facts['os']['family'] ? {
    'Debian' => 'nobody',
    'RedHat' => 'ocserv',
  }

  $run_as_group = $facts['os']['family'] ? {
    'Debian' => 'daemon',
    'RedHat' => 'ocserv',
  }

  $socket_file = $facts['os']['family'] ? {
    'Debian' => '/var/run/ocserv-socket',
    'RedHat' => 'ocserv.sock',
  }

  $chroot_dir = $facts['os']['family'] ? {
    'Debian' => undef,
    'RedHat' => '/var/lib/ocserv',
  }

  $server_cert = $facts['os']['family']? {
    'Debian' => '/etc/ssl/certs/ssl-cert-snakeoil.pem',
    'RedHat' => '/etc/pki/ocserv/public/server.crt',
  }

  $server_key = $facts['os']['family'] ? {
    'Debian' => '/etc/ssl/private/ssl-cert-snakeoil.key',
    'RedHat' => '/etc/pki/ocserv/private/server.key',
  }

  package {'ocserv':}
  ->
  file {'/etc/ocserv/ocserv.conf':
    content => epp('ocserv/ocserv.conf', {'tcp_port' => $ocserv_tcp_port,
                                          'udp_port' => $ocserv_udp_port,
                                          'run_as_user' => $run_as_user,
                                          'run_as_group' => $run_as_group,
                                          'socket_file' => $socket_file,
                                          'chroot_dir' => $chroot_dir,
                                          'server_cert' => $server_cert,
                                          'server_key' => $server_key,
                                          'default_domain' => $ocserv_default_domain,
                                          'ipv4_network' => $ocserv_ipv4_network,
                                          'dns' => $ocserv_dns,
                                          'split_dns' => $ocserv_split_dns,
                                          'routes' => $ocserv_routes,
                                         }),
  }
  ~>
  service {'ocserv':
    enable => true,
    ensure => running,
  }

  if ($facts['os']['family'] == 'RedHat' and $firewall) {
    exec {'add masquerade for ocserv':
      command => '/usr/bin/firewall-cmd --permanent --add-masquerade',
      unless => '/usr/bin/firewall-cmd --query-masquerade',
      notify => Exec['reload firewall for ocserv'],
    }

    exec {'open firewall for ocserv':
      command => '/usr/bin/firewall-cmd --permanent --add-port=444/{tcp,udp}',
      unless => '/usr/bin/firewall-cmd --query-port=444/udp',
    }
    ~>
    exec {'reload firewall for ocserv':
      command => '/usr/bin/firewall-cmd --reload',
      refreshonly => true,
    }
  }

  if ($facts['os']['family'] == 'Debian') {
    file {'/etc/systemd/system/ocserv.socket.d/':
      ensure => directory,
    }
    ->
    file {'/etc/systemd/system/ocserv.socket.d/port.conf':
      content => epp('ocserv/port.conf', {'tcp_port' => $ocserv_tcp_port,
                                          'udp_port' => $ocserv_udp_port,
                                         }),
    }
    ~>
    exec {'/bin/systemctl daemon-reload && systemctl restart ocserv.socket':
      refreshonly => true,
    }
  }
}
