class postgres($pg_hba_conf) {
  package {'pgdg-redhat-repo':
    source => 'https://download.postgresql.org/pub/repos/yum/reporpms/EL-9-x86_64/pgdg-redhat-repo-latest.noarch.rpm',
  }
  ->
  package {'postgresql15-server':}
  ->
  exec {'/usr/pgsql-15/bin/postgresql-15-setup initdb':
    creates => '/var/lib/pgsql/15/data/PG_VERSION',
  }
  ->
  [
    file {'/var/lib/pgsql/15/data/pg_hba.conf':
      # template at /usr/pgsql-15/share/pg_hba.conf.sample
      content => $pg_hba_conf,
    },
    exec {'/bin/sed -i "s/#listen_addresses = \'localhost\'/listen_addresses = \'*\'         /" /var/lib/pgsql/15/data/postgresql.conf':
      unless => '/bin/grep "listen_addresses = \'\\*\'" /var/lib/pgsql/15/data/postgresql.conf',
    }
  ]
  ~>
  service {'postgresql-15':
    ensure => running,
    enable => true,
  }
}
