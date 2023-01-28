include automatic_updates
include basic_software
include root_mail

if $facts['os']['family'] == "Debian" {
  class {'debian':}
}
