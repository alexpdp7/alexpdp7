include automatic_updates

$tinc_hosts = lookup("groups.tinc")
$tinc_other_hosts = $tinc_hosts.filter |$host_name| { $host_name != $facts["networking"]["fqdn"] }

$tinc_locations = Hash($tinc_hosts.map |$host_name| { [
  lookup("hostvars.'$host_name'.network.tinc.location"),
  {
    subnet => lookup("hostvars.'$host_name'.network.self_internal_network"),
    address => lookup("hostvars.'$host_name'.network.public_hostname"),
  }
] })

$tinc_connect_to = $tinc_other_hosts.map |$host_name| { lookup("hostvars.'$host_name'.network.tinc.location") }

$tinc_other_networks = $tinc_other_hosts.map |$host_name| { lookup("hostvars.'$host_name'.network.self_internal_network") }

if 'tinc' in lookup("group_names") {
  class {'tinc':
    tinc_name           => lookup("tinc_global.name"),
    tinc_location       => lookup("network.tinc.location"),
    tinc_connect_to     => $tinc_connect_to,
    tinc_locations      => $tinc_locations,
    tinc_ip             => lookup("network.self_internal_ip"),
    tinc_netmask        => lookup("network.self_internal_netmask"),
    tinc_other_networks => $tinc_other_networks,
  }
}
