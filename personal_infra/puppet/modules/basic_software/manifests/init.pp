class basic_software {
  package {['less', 'mlocate', 'traceroute', 'nmap', 'tree', 'tar', 'screen', 'git', 'net-tools']:}

  if($facts['os']['family'] == 'RedHat') {
    package {'which':}
  }
}
