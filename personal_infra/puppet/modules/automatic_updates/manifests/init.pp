class automatic_updates {
  if ($facts['os']['family'] == 'Debian') {
    package {["unattended-upgrades", "apt-listchanges"]:}
  }
}
