class freeipa::server {
  package {['ipa-server', 'ipa-server-dns', 'ipa-healthcheck']:}
  ~>
  service {'ipa-healthcheck':
    ensure => running,
    enable => true,
  }

  # weak dependency that does not work on LXC[I
  package {'low-memory-monitor':
    ensure => purged,
  }
}
