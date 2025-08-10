class basic_software {
  package {['less', 'traceroute', 'nmap', 'tree', 'tar', 'screen', 'git', 'net-tools', 'pipx', 'rsync', 'bash-completion', 'moreutils']:}

  if($facts['os']['family'] == 'RedHat') {
    package {'which':}

    copr {'emacs-30':
      user => 'mlampe',
      dist => 'epel-9',
    }
    ->
    package {'emacs-nw':}
  }

  if ($facts['os']['family'] == 'Debian') {
    package {'emacs-nox':}
    if ($facts['os']['release']['major'] == 12) {
      file {'/etc/apt/preferences.d/90_emacs':
        content => @(EOT)
        Package: src:emacs
        Pin: release n=bookworm-backports
        Pin-Priority: 990
        | EOT
        ,
      }
      ~>
      Exec["/usr/bin/apt update"]
      ->
      Package['emacs-nox']

      package {'mlocate':}
    }
  }
}
