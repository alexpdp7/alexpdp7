class basic_software {
  package {'less':}

  if($facts['os']['family'] == 'RedHat') {
    package {'which':}
  }
}
