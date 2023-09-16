node 'nextcloud.h1.int.pdp7.net' {
  class {'nextcloud':
    database_name => 'nextcloud',
    database_user => 'nextcloud',
    database_host => 'pg.h1.int.pdp7.net',
    admin_pass => 'foo',
    data_dir => '/var/lib/nextcloud/data',
  }
}
