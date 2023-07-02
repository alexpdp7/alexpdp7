node 'pg.h1.int.pdp7.net' {
  class {'postgres':
    pg_hba_conf => @(EOT)
      # TYPE  DATABASE        USER            ADDRESS                   METHOD
      # "local" is for Unix domain socket connections only
      local   all             all                                       peer
      host    weight          k8s_prod        k8s-prod.h1.int.pdp7.net  trust
      host    weight          grafana         grafana.h2.int.pdp7.net   trust
      | EOT
    ,
  }
}
