class miniflux($database_url, $polling_frequency, $batch_size, $polling_parser_error_limit) {
    file {'/etc/yum.repos.d/miniflux.repo':
        content => "[miniflux]
name=Miniflux Repository
baseurl=https://repo.miniflux.app/yum/
enabled=1
gpgcheck=0
",
    }
    ->
    package {'miniflux':}
    ->
    file {'/etc/miniflux.conf':
        content => "LISTEN_ADDR=0.0.0.0:8080
RUN_MIGRATIONS=1
DATABASE_URL=$database_url
POLLING_FREQUENCY=$polling_frequency
BATCH_SIZE=$batch_size
POLLING_PARSING_ERROR_LIMIT=$polling_parser_error_limit
",
    }
    ~>
    service {'miniflux':
        ensure => running,
        enable => true,
    }
}
