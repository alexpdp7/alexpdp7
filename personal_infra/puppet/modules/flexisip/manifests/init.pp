class flexisip($flexisip_sdp_port_range_min, $flexisip_sdp_port_range_max, $flexisip_user_database, $flexisip_domain) {
    file {'/etc/yum.repos.d/BelledonneCom.repo':
      content => @(EOT)
      # keep this repository enabled even if you enable beta/alpha repositories
      [Belledonne-stable]
      name=Belledonne-stable
      baseurl=http://www.linphone.org/snapshots/$contentdir/$releasever/stable
      enabled=1
      gpgcheck=0

      # enable this if you want post-release patches
      [Belledonne-hotfix]
      name=Belledonne-hotfix
      baseurl=http://www.linphone.org/snapshots/$contentdir/$releasever/hotfix
      enabled=1
      gpgcheck=0

      # enable this if you want next release beta packages
      [Belledonne-beta]
      name=Belledonne-beta
      baseurl=http://www.linphone.org/snapshots/$contentdir/$releasever/beta
      enabled=0
      gpgcheck=0

      # enable this to have development (unstable) packages
      [Belledonne-alpha]
      name=Belledonne-alpha
      baseurl=http://www.linphone.org/snapshots/$contentdir/$releasever/alpha
      enabled=0
      gpgcheck=0
      | EOT
      ,
    }
    ->
    package {'bc-flexisip':}
    ->
    file {'/etc/flexisip/flexisip.conf':
      content => template('flexisip/flexisip.conf'),
    }
    ~>
    service {'flexisip-proxy':
        ensure => running,
        enable => true,
    }

    file {'/etc/flexisip/users.db.txt':
      content => $flexisip_user_database,
      require => Package['bc-flexisip'],
      notify => Service['flexisip-proxy'],
    }
}
