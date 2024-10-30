class basic_software {
  package {['less', 'mlocate', 'traceroute', 'nmap', 'tree', 'tar', 'screen', 'git', 'net-tools', 'pipx', 'rsync', 'bash-completion', 'moreutils']:}

  if($facts['os']['family'] == 'RedHat') {
    package {'which':}
  }

  if ($facts['os']['family'] == 'Debian') {
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
    package {'emacs-nox':}
  }
}
