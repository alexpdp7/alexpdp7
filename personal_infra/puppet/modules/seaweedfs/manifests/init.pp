class seaweedfs {
    file {'/etc/yum.repos.d/_copr:copr.fedorainfracloud.org:koalillo:seaweedfs.repo':
      content => @(EOT)
      [copr:copr.fedorainfracloud.org:koalillo:seaweedfs]
      name=Copr repo for seaweedfs owned by koalillo
      baseurl=https://download.copr.fedorainfracloud.org/results/koalillo/seaweedfs/rhel-9-$basearch/
      type=rpm-md
      skip_if_unavailable=True
      gpgcheck=1
      gpgkey=https://download.copr.fedorainfracloud.org/results/koalillo/seaweedfs/pubkey.gpg
      repo_gpgcheck=0
      enabled=1
      enabled_metadata=1
      | EOT
      ,
    }
    ->
    package {'seaweedfs':}
    ->
    service {'weed':
        ensure => running,
        enable => true,
    }
}
