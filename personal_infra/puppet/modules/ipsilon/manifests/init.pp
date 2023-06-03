class ipsilon {
  package {['ipsilon-tools-ipa', 'ipsilon-openidc']:}

  service {'httpd':
    ensure => running,
    enable => true,
  }
}
