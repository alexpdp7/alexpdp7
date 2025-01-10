class jellyfin {
  package {'extrepo':}
  ->
  exec {'/usr/bin/extrepo enable jellyfin':
    creates => '/etc/apt/sources.list.d/extrepo_jellyfin.sources',
  }
  ~>
  Exec["/usr/bin/apt update"]
  ->
  package {'jellyfin':}
}
