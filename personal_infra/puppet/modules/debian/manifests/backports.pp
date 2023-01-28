class debian::backports {
  $codename = $facts['os']['distro']['codename']

  file {'/etc/apt/sources.list.d/backports.list':
    content => "deb http://deb.debian.org/debian ${codename}-backports main\n",
  }
  ~>
  Exec["/usr/bin/apt update"]
}
