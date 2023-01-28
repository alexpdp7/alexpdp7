class debian {
  exec {'/usr/bin/apt update':
    refreshonly => true,
  }
}
