$dns_source_hosts = lookup("dns.source_hosts")
$dns_other_hosts = $dns_source_hosts.filter |$host_name| { $host_name != $facts["networking"]["fqdn"] }

$dns_other_server_defs = $dns_other_hosts.map |$host_name| {
  {
    network_name => join([lookup("hostvars.'$host_name'.network.network_name"), lookup('dns.internal_domain')], '.'),
    reverse_ip_range => lookup("hostvars.'$host_name'.network.self_internal_network"),
    dns_ip => lookup("hostvars.'$host_name'.network.self_internal_ip"),
  }
}
