node 'flexisip.h1.int.pdp7.net' {
  $password = lookup("flexisip.password")

  class {'flexisip':
    flexisip_domain => 'sip.pdp7.net',
    flexisip_sdp_port_range_min => '20000',
    flexisip_sdp_port_range_max => '20010',
    flexisip_user_database => @("EOT")
    version:1

    1000@sip.pdp7.net clrtxt:$password ;
    1001@sip.pdp7.net clrtxt:$password ;
    1002@sip.pdp7.net clrtxt:$password ;
    | EOT
    ,
  }
}
