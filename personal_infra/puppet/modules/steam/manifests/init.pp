class steam {
  file {'/var/lib/dpkg/arch':
    content => @(EOT)
    amd64
    i386
    | EOT
    ,
  }
  ~>
  Exec['/usr/bin/apt update']
  ->
  package {'steam-installer':}
}
