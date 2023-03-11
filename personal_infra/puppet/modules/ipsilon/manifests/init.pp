class ipsilon {
  package {'ipsilon-tools-ipa':
    source => 'https://kojipkgs.fedoraproject.org//packages/ipsilon/3.0.4/5.el8/noarch/ipsilon-tools-ipa-3.0.4-5.el8.noarch.rpm',
  }

  package {'ipsilon-openidc':
    source => 'https://kojipkgs.fedoraproject.org//packages/ipsilon/3.0.4/5.el8/noarch/ipsilon-openidc-3.0.4-5.el8.noarch.rpm',
  }

  package {'ipsilon-authpam':
    source => 'https://kojipkgs.fedoraproject.org//packages/ipsilon/3.0.4/5.el8/noarch/ipsilon-authpam-3.0.4-5.el8.noarch.rpm',
  }

  service {'httpd':
    ensure => running,
    enable => true,
  }
}
