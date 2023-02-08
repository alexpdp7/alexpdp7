class basic_software {
  package {['less', 'mlocate', 'traceroute', 'nmap', 'tree', 'tar']:}

  if($facts['os']['family'] == 'RedHat') {
    package {'which':}
  }
}
