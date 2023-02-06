class freeipa::server {
  package {['ipa-server', 'ipa-server-dns', 'ipa-healthcheck']:}

  # weak dependency that does not work on LXC[I
  package {'low-memory-monitor':
    ensure => purged,
  }
}
