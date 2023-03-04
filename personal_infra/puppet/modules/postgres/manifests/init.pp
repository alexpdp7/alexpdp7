class postgres {
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
  service {'postgresql-15':
    ensure => running,
    enable => true,
  }
}
