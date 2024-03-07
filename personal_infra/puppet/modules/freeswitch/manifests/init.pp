class freeswitch($freeswitch_password, $freeswitch_address, $freeswitch_rtp_start_port, $freeswitch_rtp_end_port) {
  package {'okay-release':
    source => 'http://repo.okay.com.mx/centos/9/x86_64/release/okay-release-1-10.el9.noarch.rpm',
  }
  ->
  package {['freeswitch-config-vanilla', 'freeswitch-systemd', 'freeswitch-sounds-en-us-callie-all']:}
  ->
  service {'freeswitch':
    enable => true,
    ensure => running,
  }

  file {'/etc/freeswitch/vars.xml':
      content => template('freeswitch/vars.xml'),
      require => Package['freeswitch-config-vanilla'],
      notify => Service['freeswitch'],
  }

  file {'/etc/freeswitch/autoload_configs/switch.conf.xml':
      content => template('freeswitch/switch.conf.xml'),
      require => Package['freeswitch-config-vanilla'],
      notify => Service['freeswitch'],
  }
}
