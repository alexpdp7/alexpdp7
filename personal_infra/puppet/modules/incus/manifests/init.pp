class incus($network_device) {
  file {'/etc/apt/keyrings/zabbly.asc':
    content => @(EOT)
    -----BEGIN PGP PUBLIC KEY BLOCK-----

    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
    =8Uc6
    -----END PGP PUBLIC KEY BLOCK-----
    | EOT
    ,
  }
  ~>
  Exec['/usr/bin/apt update']

  $codename = $facts['os']['distro']['codename']
  $arch = $facts['os']['architecture']

  file {'/etc/apt/sources.list.d/zabbly-incus-stable.sources':
    content => @("EOT")
    Enabled: yes
    Types: deb
    URIs: https://pkgs.zabbly.com/incus/stable
    Suites: $codename
    Components: main
    Architectures: $arch
    Signed-By: /etc/apt/keyrings/zabbly.asc
    | EOT
    ,
  }
  ~>
  Exec['/usr/bin/apt update']

  Exec['/usr/bin/apt update']
  ->
  package {'incus':}

  file {'/etc/incus.puppet':
    content => @("EOT")
    config: {}
    networks:
    - config:
        ipv4.address: auto
        ipv6.address: auto
      description: ""
      name: incusbr0
      type: ""
      project: default
    storage_pools:
    - config: {}
      description: ""
      name: default
      driver: dir
    profiles:
    - config: {}
      description: ""
      devices:
        eth0:
          name: $network_device
          network: incusbr0
          type: nic
        root:
          path: /
          pool: default
          type: disk
      name: default
    projects: []
    cluster: null
    | EOT
    ,
  }

  exec {'/usr/bin/incus admin init --preseed </etc/incus.puppet':
    require => [
      File['/etc/incus.puppet'],
      Package['incus'],
    ],
  }
}
