class grafana($root_url, $oidc_client_id, $oidc_client_secret, $oidc_auth_url, $oidc_api_url, $oidc_token_url) {
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
  file {'/etc/grafana/grafana.ini':
    content => @("EOT")
      [server]
      root_url=$root_url

      [auth.generic_oauth]
      enabled = true
      allow_sign_up = true
      name = idp.pdp7.net
      client_id = $oidc_client_id
      client_secret = $oidc_client_secret
      auth_url = $oidc_auth_url
      api_url = $oidc_api_url
      token_url = $oidc_token_url
      scopes = openid email profile
      | EOT
    ,
  }
  ~>
  service {'grafana-server':
    enable => true,
    ensure => running,
  }
}
