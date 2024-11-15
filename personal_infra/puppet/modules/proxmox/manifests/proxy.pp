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

  ['md', 'ssl', 'proxy_http', 'proxy'].each |$mod| {
    exec {"/usr/sbin/a2enmod $mod":
      creates => "/etc/apache2/mods-enabled/$mod.load",
      * => $apache_dep,
    }
  }

  file {'/etc/apache2/sites-enabled/test.conf':
    content => @("EOT")
    MDomain $base_hostname auto
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

    pvenode cert set /etc/apache2/md/domains/$base_hostname/pubcert.pem /etc/apache2/md/domains/$base_hostname/privkey.pem  --force 1 --restart 1

    for hook in /usr/local/bin/notify_md_renewal_hook_* ; do
      \$hook
    done
    | EOT
    ,
    mode => '4755',
  }

  service {'nagios':}
  package {'nagios':
    ensure => absent,
  }

  nagios_service {"$base_hostname-proxmox-cert":
    use => 'generic-service',
    service_description => "$base_hostname-proxmox-cert",
    host_name => $base_hostname,
    check_command => "check_$base_hostname-proxmox-cert",
    require => Package['nagios'],
    notify => Service['nagios'],
    owner => 'nagios',
  }

  nagios_command {"check_$base_hostname-proxmox-cert":
    command_name => "check_$base_hostname-proxmox-cert",
    command_line => "/usr/lib64/nagios/plugins/check_http -H $base_hostname -C 10,5 -p 8006",
    require => Package['nagios'],
    notify => Service['nagios'],
    owner => 'nagios',
  }
}
