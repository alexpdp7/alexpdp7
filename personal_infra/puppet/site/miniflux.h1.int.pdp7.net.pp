node 'miniflux.h1.int.pdp7.net' {
  class {'miniflux':
    database_url => "host=pg.h1.int.pdp7.net user=miniflux dbname=miniflux sslmode=disable",
    polling_frequency => 60,
    batch_size => 100,
    polling_parser_error_limit => 0,
  }
}
