include automatic_updates

$tinc_hosts = lookup("'$ansible_inventory_hostname'.groups.tinc")
$tinc_other_hosts = $tinc_hosts.filter |$host_name| { $host_name != $ansible_inventory_hostname }

$tinc_locations = Hash($tinc_hosts.map |$host_name| { [
  lookup("'$host_name'.network.tinc.location"),
  {
    subnet => lookup("'$host_name'.network.self_internal_network"),
    address => lookup("'$host_name'.network.public_hostname"),
  }
] })

$tinc_connect_to = $tinc_other_hosts.map |$host_name| { lookup("'$host_name'.network.tinc.location") }

$tinc_other_networks = $tinc_other_hosts.map |$host_name| { lookup("'$host_name'.network.self_internal_network") }

if 'tinc' in lookup("'$ansible_inventory_hostname'.group_names") {
  class {'tinc':
    tinc_name           => lookup("'$ansible_inventory_hostname'.tinc_global.name"),
    tinc_location       => lookup("'$ansible_inventory_hostname'.network.tinc.location"),
    tinc_connect_to     => $tinc_connect_to,
    tinc_locations      => $tinc_locations,
    tinc_ip             => lookup("'$ansible_inventory_hostname'.network.self_internal_ip"),
    tinc_netmask        => lookup("'$ansible_inventory_hostname'.network.self_internal_netmask"),
    tinc_other_networks => $tinc_other_networks,
  }
}
