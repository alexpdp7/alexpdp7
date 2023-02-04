class basic_software {
  package {['less', 'mlocate']:}

  if($facts['os']['family'] == 'RedHat') {
    package {'which':}
  }
}
