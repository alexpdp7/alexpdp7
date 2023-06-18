node 'h1.pdp7.net' {
  class {'proxmox::freeipa':}
  class {'dns_dhcp':}

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

  proxmox::proxy_host {'ipsilon-test.pdp7.net':
    target => 'https://ipsilon-test.h1.int.pdp7.net/',
    overwrite_rh_certs => 'ipsilon-test.h1.int.pdp7.net',
  }
}
