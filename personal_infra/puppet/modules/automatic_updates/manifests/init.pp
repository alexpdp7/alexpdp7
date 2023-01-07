class automatic_updates {
  if ($osfamily == 'Debian') {
    package {["unattended-upgrades", "apt-listchanges"]:}
  }
}
