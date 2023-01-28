include automatic_updates

if $facts['os']['family'] == "Debian" {
  class {'debian':}
}
