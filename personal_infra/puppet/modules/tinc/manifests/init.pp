class tinc($tinc_name, $tinc_location, $tinc_connect_to, $tinc_locations, $tinc_ip, $tinc_netmask, $tinc_other_networks) {
  package {'tinc':}
  ->
  file {'/etc/tinc':
    ensure => directory,
  }
  ->
  file {"/etc/tinc/${tinc_name}":
    ensure => directory,
  }
  ->
  file {"/etc/tinc/${tinc_name}/hosts":
    ensure => directory,
  }
  ->
  file {"/etc/tinc/${tinc_name}/tinc.conf":
    content => epp('tinc/tinc.conf', {'tinc_name'       => $tinc_name,
                                      'tinc_location'   => $tinc_location,
                                      'tinc_connect_to' => $tinc_connect_to,
                                      }),
    notify => Service["tinc@${tinc_name}"],
  }

  $tinc_locations.each |$name, $location| {
    file {"/etc/tinc/${tinc_name}/generate_host_${name}.sh":
      content => "#!/bin/sh

set -ue

echo Subnet = ${location['subnet']} >/etc/tinc/${tinc_name}/hosts/${name}
echo Address = ${location['address']} >>/etc/tinc/${tinc_name}/hosts/${name}
cat /etc/ansible/tinc/public_${location['address']}.pem >>/etc/tinc/${tinc_name}/hosts/${name}
      ",
      mode => '755',
    }
    ~> 
    exec {"/etc/tinc/${tinc_name}/generate_host_${name}.sh":
      require => File["/etc/tinc/${tinc_name}/hosts"],
      notify => Service["tinc@${tinc_name}"],
      creates => "/etc/tinc/${tinc_name}/hosts/${name}",
    }
  }

  service {"tinc@${tinc_name}":
    ensure => running,
    enable => true,
  }

  exec {"/bin/cp /etc/ansible/tinc/private.pem /etc/tinc/${tinc_name}/rsa_key.priv":
    creates => "/etc/tinc/${tinc_name}/rsa_key.priv",
    require => File["/etc/tinc/${tinc_name}"],
    notify => Service["tinc@${tinc_name}"],
  }

  file {"/etc/tinc/${tinc_name}/tinc-up":
    content => epp('tinc/tinc-up', {'ip' => $tinc_ip,
                                    'netmask' => $tinc_netmask,
                                    'tinc_other_networks' => $tinc_other_networks,}),
    require => File["/etc/tinc/${tinc_name}"],
    mode => '777',
    notify => Service["tinc@${tinc_name}"],
  }

  if ($osfamily == 'RedHat') {
    exec {'open firewall for tinc':
      command => '/usr/bin/firewall-cmd --permanent --add-port=655/{tcp,udp}',
      unless => '/usr/bin/firewall-cmd --query-port=655/udp',
    }
    ~>
    exec {'reload firewall for tinc':
      command => '/usr/bin/firewall-cmd --reload',
      refreshonly => true,
    }
  }

  file {'/etc/sysctl.d/tinc.conf':
    content => "net.ipv4.ip_forward=1\nnet.ipv4.conf.all.proxy_arp=0\n",
  }
  ~>
  exec {'reload sysctl for tinc':
    command => '/sbin/sysctl --system',
    refreshonly => true,
  }
}
