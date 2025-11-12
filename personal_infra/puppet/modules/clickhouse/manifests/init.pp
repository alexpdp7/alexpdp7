class clickhouse {
  file {'/etc/yum.repos.d/clickhouse.repo':
    content => @(EOT)
      [clickhouse-stable]
      name=ClickHouse - Stable Repository
      baseurl=https://packages.clickhouse.com/rpm/stable/
      gpgkey=https://packages.clickhouse.com/rpm/stable/repodata/repomd.xml.key
      gpgcheck=0
      repo_gpgcheck=1
      enabled=1

      [clickhouse-lts]
      name=ClickHouse - LTS Repository
      baseurl=https://packages.clickhouse.com/rpm/lts/
      gpgkey=https://packages.clickhouse.com/rpm/lts/repodata/repomd.xml.key
      gpgcheck=0
      repo_gpgcheck=1
      enabled=0
      | EOT
    ,
  }
  ->
  package {['clickhouse-server', 'clickhouse-client']:}
  ->
  [File['/etc/clickhouse-server/config.d/network.xml'], File['/etc/clickhouse-server/config.d/logs.xml']]
  ~>
  service {['clickhouse-server']:
    ensure => running,
    enable => true,
  }

  file {'/etc/clickhouse-server/config.d/network.xml':
    content => @(EOT)
      <clickhouse>
        <listen_host>::</listen_host>
      </clickhouse>
      | EOT
    ,
  }

  file {'/etc/clickhouse-server/config.d/logs.xml':
    content => @(EOT)
      <clickhouse>
        <asynchronous_metric_log>
          <ttl>event_date + INTERVAL 3 DAY DELETE</ttl>
        </asynchronous_metric_log>
        <trace_log remove="1"/>
        <metric_log>
          <ttl>event_date + INTERVAL 3 DAY DELETE</ttl>
        </metric_log>
        <query_log>
          <ttl>event_date + INTERVAL 3 DAY DELETE</ttl>
        </query_log>
        <text_log>
          <ttl>event_date + INTERVAL 3 DAY DELETE</ttl>
        </text_log>
      </clickhouse>
    | EOT
    ,
  }
}
