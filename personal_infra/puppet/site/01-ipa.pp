$ipa_client_package = case $facts['os']['family'] {
  'Debian': { 'freeipa-client' }
  'RedHat': { 'ipa-client' }
  default: { fail($facts['os']['family']) }
}

if $facts['os']['family'] == 'Debian' and $facts['os']['release']['major'] == "11" {
  class {'debian::backports':}
  ->
  Package[$ipa_client_package]
}

package {$ipa_client_package:}
