node 'case.ces.int.pdp7.net' {
  file {'/etc/resolv.conf':
    content => @(EOT)
    domain ces.int.pdp7.net
    search ces.int.pdp7.net
    nameserver 10.17.19.4
    | EOT
    ,
  }
  # nmbd does not start correctly when wg is up. stop wg, restart nmb, start wg
}
