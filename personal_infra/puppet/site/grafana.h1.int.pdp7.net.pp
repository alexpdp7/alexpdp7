node 'grafana.h1.int.pdp7.net' {
  class {'grafana':
    oidc_client_id =>     lookup('grafana.oauth.client_id'),
    oidc_client_secret => lookup('grafana.oauth.client_secret'),
    oidc_auth_url      => lookup('grafana.oauth.auth_url'),
    oidc_api_url       => lookup('grafana.oauth.api_url'),
    oidc_token_url     => lookup('grafana.oauth.token_url'),
    root_url => 'https://grafana.pdp7.net',
  }
}
