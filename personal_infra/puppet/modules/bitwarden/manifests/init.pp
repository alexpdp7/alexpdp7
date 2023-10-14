class bitwarden {
    file {'/etc/yum.repos.d/koalillo-vaultwarden-epel-9.repo':
        content => '[copr:copr.fedorainfracloud.org:koalillo:vaultwarden]
name=Copr repo for vaultwarden owned by koalillo
baseurl=https://download.copr.fedorainfracloud.org/results/koalillo/vaultwarden/epel-9-$basearch/
type=rpm-md
skip_if_unavailable=True
gpgcheck=1
gpgkey=https://download.copr.fedorainfracloud.org/results/koalillo/vaultwarden/pubkey.gpg
repo_gpgcheck=0
enabled=1
enabled_metadata=1
',
    }
    ->
    package {'bitwarden_rs':}
    ->
    service {'bitwarden_rs':
        ensure => running,
        enable => true,
    }
}
