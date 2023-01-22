$ipa_client_package = case $facts['os']['family'] {
  'Debian': { 'freeipa-client' }
  'RedHat': { 'ipa-client' }
  default: { fail($facts['os']['family']) }
}

package {$ipa_client_package:}
