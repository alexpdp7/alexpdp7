class root_mail {
  package {['postfix', 'sendmail']:
    ensure => absent,
  }

  package {'msmtp':}

  if $facts['os']['family'] == "Debian" {
    package {'msmtp-mta':}
  }

  $cron_service = case $facts['os']['family'] {
    'Debian': { 'cron' }
    'RedHat': { 'crond' }
    default: { fail($facts['os']['family']) }
  }

  # if crond doesn't see /usr/bin/sendmail on startup, it won't send mails
  Package['msmtp']
  ~>
  service{$cron_service:
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

  $host = lookup('mail.ses_endpoint')
  $user = lookup('mail.ses_username')
  $password = lookup('mail.ses_password')
  $from = join([$facts['networking']['fqdn'], "@", lookup('mail.ses_domain')])

  file {'/etc/msmtprc':
    content => @("EOT")
    defaults
    tls on
    tls_starttls on
    tls_trust_file system
    syslog on

    account default
    host $host
    port 587
    auth on
    user $user
    password $password
    from $from
    allow_from_override off
    undisclosed_recipients on
    set_from_header on

    aliases /etc/aliases
    | EOT
    ,
  }

  $root_mail = lookup('mail.root_mail')

  file {'/etc/aliases':
    content => @("EOT")
    default: $root_mail
    | EOT
    ,
  }
}
