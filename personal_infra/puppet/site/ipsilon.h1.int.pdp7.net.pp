node 'ipsilon.h1.int.pdp7.net' {
  class {'ipsilon':
    session_timeout_minutes => 60*24*7,
  }
}
