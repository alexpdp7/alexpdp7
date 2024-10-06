if 'dyndns' in lookup("group_names") {
  $ddns_secret = lookup({name => 'network.ddns_secret'})
  $ddns_domain = lookup({name => 'dyndns.domain'})
  $host_name = lookup({name => 'network.public_hostname'})

  file {"/etc/cron.hourly/route53_dyndns":
    content => @("EOT")
    #!/bin/sh

    /usr/bin/curl -s >/dev/null "https://${ddns_domain}.execute-api.eu-central-1.amazonaws.com/prod/updateDdns?host_name=${host_name}&secret=${ddns_secret}"
    | EOT
    ,
    mode => '0755',
  }
}
