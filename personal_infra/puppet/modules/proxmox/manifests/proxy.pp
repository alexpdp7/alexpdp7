class proxmox::proxy ($mail, $base_hostname) {
  package {'apache2':}
  ->
  service {'apache2':
    enable => true,
    ensure => running,
    require => File['/usr/local/bin/notify_md_renewal'],
  }

  $apache_dep = {
    require => Package['apache2'],
    notify => Service['apache2'],
  }

  ['md', 'ssl'].each |$mod| {
    exec {"/usr/sbin/a2enmod $mod":
      creates => "/etc/apache2/mods-enabled/$mod.load",
      * => $apache_dep,
    }
  }

  file {'/etc/apache2/sites-enabled/test.conf':
    content => @("EOT")
    MDomain $base_hostname
    MDCertificateAgreement accepted
    MDContactEmail $mail
    MDNotifyCmd /usr/local/bin/notify_md_renewal

    <VirtualHost *:443>
      ServerName $base_hostname
      SSLEngine on
    </VirtualHost>
    | EOT
    ,
    * => $apache_dep
  }

  file {'/usr/local/bin/notify_md_renewal':
    content => @("EOT"/$)
    #!/bin/sh

    mail $mail -s "Restart apache2 on $base_hostname for certificate \$1" </dev/null
    | EOT
    ,
    mode => '0755',
  }
}
