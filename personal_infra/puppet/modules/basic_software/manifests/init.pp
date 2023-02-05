class basic_software {
  package {['less', 'mlocate', 'traceroute', 'nmap']:}

  if($facts['os']['family'] == 'RedHat') {
    package {'which':}
  }
}
