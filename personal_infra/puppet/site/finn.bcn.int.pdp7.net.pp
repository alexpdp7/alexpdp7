node 'finn.bcn.int.pdp7.net' {
  class {'tvheadend':}
  class {'filer::client':
    server => 'dixie.bcn.int.pdp7.net',
  }
}
