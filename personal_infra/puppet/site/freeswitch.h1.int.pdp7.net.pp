node 'freeswitch.h1.int.pdp7.net' {
  class {'freeswitch':
    freeswitch_password => lookup("freeswitch.password"),
    freeswitch_address => 'stun:stun.freeswitch.org',
    freeswitch_rtp_start_port => '20000',
    freeswitch_rtp_end_port => '20010',
  }
}
