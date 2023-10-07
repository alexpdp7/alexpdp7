node 'h1.pdp7.net' {
  class {'proxmox::freeipa':}
  class {'dns_dhcp':}

  class {'backups':
    sanoid_config =>  @("EOT")
      # pg data
      [rpool/data/subvol-204-disk-1]
        use_template = backup

      [template_backup]
        frequently=0
        hourly=0
        daily=100000
        monthly=0
        yearly=0
        autosnap=yes
      | EOT
    ,
  }

  # TODO: ugly; tinc scripts require this :(
  package {'net-tools':}

  # https://lists.fedorahosted.org/archives/list/freeipa-users@lists.fedorahosted.org/thread/EZSM6LQPSNRY4WA52IYVR46RSXIDU3U7/
  # SSH hack
  file {'/etc/ssh/sshd_config.d/weak-gss.conf':
    content => "GSSAPIStrictAcceptorCheck no\n",
  }
  ~>
  service {'sshd':}

  class {'proxmox::proxy':
    mail => lookup('mail.root_mail'),
    base_hostname => lookup('network.public_hostname'),
  }

  proxmox::proxy_host {'idp.pdp7.net':
    target => 'https://ipsilon.h1.int.pdp7.net/',
    overwrite_rh_certs => 'ipsilon.h1.int.pdp7.net',
  }

  proxmox::proxy_host {'weight.pdp7.net':
    target => 'https://k8s-prod.h1.int.pdp7.net/',
  }

  proxmox::proxy_host {'blog.pdp7.net':
    target => 'https://k8s-test.h1.int.pdp7.net/',
  }

  proxmox::proxy_host {'miniflux.pdp7.net':
    target => 'http://miniflux.h1.int.pdp7.net:8080/',
  }
}
