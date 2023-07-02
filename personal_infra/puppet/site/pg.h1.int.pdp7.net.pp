node 'pg.h1.int.pdp7.net' {
  class {'postgres':
    pg_hba_conf => @(EOT)
      # TYPE  DATABASE        USER            ADDRESS                   METHOD
      # "local" is for Unix domain socket connections only
      local   all             all                                       peer
      host    k8s_test        k8s_test        k8s-prod.h1.int.pdp7.net  trust
      | EOT
    ,
  }
}
