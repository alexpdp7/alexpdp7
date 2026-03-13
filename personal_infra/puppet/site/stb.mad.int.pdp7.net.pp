node 'stb.mad.int.pdp7.net' {
  # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1026008
  Package[$ipa_client_package]
  ->
  service {['sssd-pam-priv.socket", "sssd-sudo.socket", "sssd-nss.socket']:
    ensure => stopped,
    enable => mask,
  }
  ~>
  Exec['/usr/bin/systemctl reset-failed']

  user {'kodi':
    ensure => present,
  }

  package {['kodi', 'lightdm']:}

  file {'/srv/filer':
    ensure => directory,
  }

  package {'nfs-common':}
  ->
  file {'/etc/systemd/system/srv-filer.mount':
    content => @(EOT)
    [Mount]
    What=dixie.bcn.int.pdp7.net:/srv/filer
    Where=/srv/filer
    Type=nfs

    [Install]
    WantedBy=multi-user.target
    | EOT
  }
  ~>
  exec {'/usr/bin/systemctl daemon-reload':}
  ->
  service {'srv-filer.mount':
    ensure => running,
    enable => true,
    require => File['/srv/filer'],
  }

  file {'/etc/lightdm/lightdm.conf':
    content => @(EOT)
    [Seat:*]
    user-session=kodi
    autologin-user=kodi
    | EOT
    ,
    require => [Package['kodi'], User['kodi']],
  }
  ~>
  service {'lightdm':}
}
