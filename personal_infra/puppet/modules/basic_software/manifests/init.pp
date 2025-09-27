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

    file {'/usr/share/keyrings/wezterm-fury.gpg':
      content => @(EOT)
      -----BEGIN PGP PUBLIC KEY BLOCK-----

      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
      qR+u
      =aOe5
      -----END PGP PUBLIC KEY BLOCK-----
      | EOT
      ,
    }
    ~>
    Exec["/usr/bin/apt update"]

    file {'/etc/apt/sources.list.d/wezterm.list':
      content => 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *',
    }
    ~>
    Exec["/usr/bin/apt update"]

    Exec["/usr/bin/apt update"]
    ->
    package {'wezterm':}
  }
}
