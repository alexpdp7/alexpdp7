node 'pg.h1.int.pdp7.net' {
  class {'postgres':
    pg_hba_conf => @(EOT)
      # TYPE  DATABASE        USER            ADDRESS                   METHOD
      # "local" is for Unix domain socket connections only
      local   all             all                                       peer
      host    weight          k8s_prod        k8s-prod.h1.int.pdp7.net  trust
      host    weight          grafana         grafana.h2.int.pdp7.net   trust
      host    weight          grafana         grafana.h1.int.pdp7.net   trust
      host    weight          nagios          nagios.h1.int.pdp7.net    trust
      host    miniflux        miniflux        miniflux.h1.int.pdp7.net  trust
      host    nextcloud       nextcloud       nextcloud.h1.int.pdp7.net trust
      | EOT
    ,
  }

  package {'postgresql15-contrib':} # hstore for miniflux

  nagios_service {'medication':
    use => 'generic-service',
    service_description => 'medication',
    host_name => 'pg.h1.int.pdp7.net',
    check_command => 'check_medication',
    require => Package['nagios'],
    notify => Service['nagios'],
    owner => 'nagios',
  }

  service {'nagios':}
  package {'nagios':
    ensure => absent,
  }

  nagios_command {'check_medication':
    command_name => 'check_medication',
    command_line => '/usr/lib64/nagios/plugins/check_pgsql -H $HOSTADDRESS$ -l nagios -d weight -q "select extract(epoch from now() - max(taken_at)) / 60 / 60 from weight.pressure_medication" -W 24 -C 25',
    require => Package['nagios'],
    notify => Service['nagios'],
    owner => 'nagios',
  }
}
