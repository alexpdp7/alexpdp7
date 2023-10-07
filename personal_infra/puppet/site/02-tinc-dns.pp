if($facts['os']['family'] == 'RedHat' and $facts['os']['release']['major'] == '9' and 'tinc' in lookup("group_names") and 'dns' in lookup("group_names")) {
  exec {'/bin/sed -i "s/^bind-interfaces/bind-dynamic #bind-interfaces/" /etc/dnsmasq.conf':
    unless => '/bin/grep "bind-dynamic #bind-interfaces" /etc/dnsmasq.conf',
  }
}
