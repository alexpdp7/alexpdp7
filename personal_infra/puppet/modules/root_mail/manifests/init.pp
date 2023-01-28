class root_mail {
  package {'postfix':}
  ->
  service {'postfix':
    ensure => running,
    enable => true,
  }

  # if crond doesn't see /usr/bin/sendmail on startup, it won't send mails
  Package['postfix']
  ~>
  service{"crond":
    ensure => running,
  }

  if($facts['os']['family'] == 'RedHat') {
    if($facts['os']['release']['major'] == '9') {
      package {'s-nail':}
    }
    else {
      package {'mailx':}
    }
  }

  mailalias {'root':
    recipient => lookup('mail.root_mail'),
    require => Package['postfix'],
  }
  ~>
  exec {'/usr/sbin/postalias /etc/aliases':
    creates => '/etc/aliases.db',
  }
  ~>
  Service['postfix']
}
