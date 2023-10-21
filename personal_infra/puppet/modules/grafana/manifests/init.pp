class grafana {
  file {'/etc/yum.repos.d/grafana.repo':
    content => @("EOT")
      [grafana]
      name=grafana
      baseurl=https://rpm.grafana.com
      repo_gpgcheck=1
      enabled=1
      gpgcheck=1
      gpgkey=https://rpm.grafana.com/gpg.key
      sslverify=1
      sslcacert=/etc/pki/tls/certs/ca-bundle.crt
      | EOT
    ,
  }
  ->
  package {'grafana':
    require => File['/etc/yum.repos.d/grafana.repo'],
  }
  ->
  service {'grafana-server':
    enable => true,
    ensure => running,
  }
}
