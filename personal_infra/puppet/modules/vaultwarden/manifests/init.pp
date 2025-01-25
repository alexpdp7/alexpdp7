class vaultwarden {
  package {['vaultwarden', 'vaultwarden-web']:}
  ->
  file {'/var/lib/vaultwarden/data':
    ensure => directory,
    owner => 'vaultwarden',
    group => 'vaultwarden',
    mode => '700',
  }
  ->
  service {'vaultwarden':
    ensure => running,
    enable => true,
  }

  Package['vaultwarden']
  ->
  file {'/etc/vaultwarden/vaultwarden.cfg':
    content => @(EOT)
    # see https://src.fedoraproject.org/rpms/vaultwarden/blob/rawhide/f/vaultwarden.cfg

    # uncomment temporarily
    SIGNUPS_ALLOWED=false
    WEB_VAULT_FOLDER=/usr/share/vaultwarden-web
    ROCKET_ADDRESS=0.0.0.0
    | EOT
    ,
  }
  ~>
  Service['vaultwarden']
}
