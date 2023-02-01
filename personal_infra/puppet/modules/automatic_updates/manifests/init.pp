class automatic_updates {
  if ($facts['os']['family'] == 'Debian') {
    package {["unattended-upgrades", "apt-listchanges"]:}
  }
  elsif ($facts['os']['family'] == 'RedHat') {
    if ($facts['os']['release']['major'] == '7') {
      package {'yum-cron':}
      ->
      file {"/etc/yum/yum-cron.conf":
        content => epp('automatic_updates/yum-cron.conf'),
      }
      ~>
      service {'yum-cron':
        ensure => running,
        enable => true,
      }
    }
    elsif ($facts['os']['release']['major'] == '8' or $facts['os']['release']['major'] == '9') {
      package {'dnf-automatic':}
      ->
      service {'dnf-automatic-install.timer':
        ensure => running,
        enable => true,
      }
    }
    else {
      fail($facts['os']['release']['major'])
    }
  }
  else {
    fail($facts['os'])
  }
}
