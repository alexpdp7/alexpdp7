node 'h1.pdp7.net' {
  class {'proxmox::freeipa':}
  class {'dns_dhcp':}
  class {'dns_dhcp::opennic':}

  class {'backups':
    sanoid_config =>  @("EOT")
      # pg data
      [rpool/data/subvol-204-disk-1]
        frequently=0
        hourly=0
        daily=10
        monthly=3
        yearly=0
        autosnap=yes

      # ws
      [rpool/data/subvol-207-disk-1]
        use_template = backup

      # nextcloud
      [rpool/data/subvol-208-disk-1]
        use_template = backup

      # bitwarden
      [rpool/data/subvol-210-disk-1]
        use_template = backup

      # gitolite
      [rpool/data/subvol-211-disk-1]
        use_template = backup

      # weed
      [rpool/data/subvol-214-disk-1]
        use_template = backup

      # vaultwarden
      [rpool/data/subvol-215-disk-1]
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

  proxmox::proxy_host {'alex.corcoles.net':
    target => 'https://k8s-prod.h1.int.pdp7.net/',
  }

  proxmox::proxy_host {'miniflux.pdp7.net':
    target => 'http://miniflux.h1.int.pdp7.net:8080/',
  }

  proxmox::proxy_host {'nextcloud.pdp7.net':
    target => 'http://nextcloud.h1.int.pdp7.net/',
  }

  proxmox::proxy_host {'vaultwarden.pdp7.net':
    target => 'http://vaultwarden.h1.int.pdp7.net:8000/',
  }

  proxmox::proxy_host {'grafana.pdp7.net':
    target => 'http://grafana.h1.int.pdp7.net:3000/',
  }

  proxmox::proxy_host {'femto.pub':
    target => 'http://k8s-prod.h1.int.pdp7.net/',
  }

  proxmox::proxy_host {'alex.femto.pub':
    target => 'http://k8s-prod.h1.int.pdp7.net/',
  }

  proxmox::proxy_host {'media.femto.pub':
    target => 'http://weed.h1.int.pdp7.net:8333/',
  }

  file {"/etc/apache2/sites-enabled/morera79.pdp7.net.conf":
    content => @("EOT")
      MDomain morera79.pdp7.net

      <VirtualHost *:80>
        ServerName morera79.pdp7.net
        Redirect permanent / https://morera79.pdp7.net/
      </VirtualHost>

      <VirtualHost *:443>
        ServerName morera79.pdp7.net
        SSLEngine on
        Alias / /bogus
        ErrorDocument 403 "<html><body>Conservo lo que hab&iacute;a aqu&iacute;, escr&iacute;beme a alex arroba corcoles punto net.</body></html>"
      </VirtualHost>
      | EOT
    ,
  }
  ~>
  Service['apache2']

  # bogus host to obtain a certificate for sip.pdp7.net
  file {"/etc/apache2/sites-enabled/sip.pdp7.net.conf":
    content => @("EOT")
      MDomain sip.pdp7.net

      <VirtualHost *:443>
        ServerName sip.pdp7.net
        SSLEngine on
        Alias / /bogus
      </VirtualHost>
      | EOT
    ,
  }
  ~>
  Service['apache2']

  file {"/usr/local/bin/notify_md_renewal_hook_sip":
    content => @("EOT"/$)
    #!/bin/sh

    cp /etc/apache2/md/domains/sip.pdp7.net/pubcert.pem  /rpool/data/subvol-209-disk-0/etc/pki/tls/certs/localhost.crt
    cp /etc/apache2/md/domains/sip.pdp7.net/privkey.pem  /rpool/data/subvol-209-disk-0/etc/pki/tls/private/localhost.key
    pct exec 209 systemctl restart flexisip-proxy
    | EOT
    ,
    mode => '0755',
  }
}
