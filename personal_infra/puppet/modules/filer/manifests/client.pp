class filer::client ($server) {
  file {'/srv/filer':
    ensure => directory,
  }
  ->
  file {'/etc/systemd/system/srv-filer.mount':
    content => @("EOT")
    [Mount]
    What=${server}:/srv/filer
    Where=/srv/filer
    Type=nfs

    [Install]
    WantedBy=multi-user.target
    | EOT
    ,
  }
  ~>
  exec {'/bin/systemctl daemon-reload':
    refreshonly => true,
  }
  ->
  service {'srv-filer.mount':
    ensure => running,
    enable => true,
  }

  package {'nfs-common':}
  ->
  Service['srv-filer.mount']
}
