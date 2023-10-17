class basic_software {
  package {['less', 'mlocate', 'traceroute', 'nmap', 'tree', 'tar', 'screen', 'git']:}

  if($facts['os']['family'] == 'RedHat') {
    package {'which':}
  }
}
