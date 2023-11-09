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
  package {['clickhouse-server', 'clickhouse-client', 'clickhouse-keeper']:}
  ->
  service {['clickhouse-server', 'clickhouse-keeper']:
    ensure => running,
    enable => true,
  } 
}
