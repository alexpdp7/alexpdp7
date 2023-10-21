node 'dixie.bcn.int.pdp7.net' {
  class {'dns_dhcp':}
  file {'/etc/dnsmasq.d/static.conf':
    content => "host-record=router,router.bcn.int.pdp7.net,192.168.76.1
host-record=archerc7,archerc7.bcn.int.pdp7.net,192.168.76.6
host-record=dixie.bcn.int.pdp7.net,dixie,192.168.76.2
dhcp-option=121,10.0.0.0/8,192.168.76.2
",
    notify => Service["dnsmasq"],
  }

  class {'backups':
    sanoid_config => "",
  }

  file {'/usr/local/sbin/zfs_receive_h2':
    content => @(EOT)
      #!/bin/bash

      set -ue

      run_backups_remote() {
        host=$1
        shift
              sudo -u backups sh -c "export KRB5CCNAME=KEYRING:persistent:1284000004 && kinit -k -t /home/backups/.keytab backups && ssh $host $*"
      }

      get_last_remote_snapshot() {
        host=$1
        fs=$2
              run_backups_remote $host /sbin/zfs list -H -t snapshot $fs | tail -1 | cut -f 1 | cut -d @ -f 2
      }

      get_last_local_snapshot() {
              zfs list -H -t snapshot $1 | tail -1 | cut -f 1 | cut -d @ -f 2
      }

      replicate() {
        host=$1
              remote=$2
              local=$3

              last_local=$(get_last_local_snapshot $local)
              last_remote=$(get_last_remote_snapshot $host $remote)

              if test $last_local != $last_remote ; then
                      run_backups_remote $host /sbin/zfs send -w -i @$last_local $remote@$last_remote | zfs receive $local
              fi
      }

      replicate case.ces.int.pdp7.net rpool/user/backed/cesar cesar_hdd_red_2/cesar
      replicate case.ces.int.pdp7.net rpool/user/backed/filer cesar_hdd_red_2/filer

      sudo -u backups /usr/sbin/syncoid --no-privilege-elevation --no-sync-snap backups@h1.pdp7.net:rpool/data/subvol-204-disk-1 rpool/user/backed/pg-h1-int-pg --quiet
      sudo -u backups /usr/sbin/syncoid --no-privilege-elevation --no-sync-snap backups@h1.pdp7.net:rpool/data/subvol-208-disk-1 rpool/user/backed/nextcloud_new --quiet
      sudo -u backups /usr/sbin/syncoid --no-privilege-elevation --no-sync-snap backups@h1.pdp7.net:rpool/data/subvol-210-disk-1 rpool/user/backed/bitwarden --quiet
      sudo -u backups /usr/sbin/syncoid --no-privilege-elevation --no-sync-snap backups@h1.pdp7.net:rpool/data/subvol-211-disk-1 rpool/user/backed/gitolite --quiet
      | EOT
    ,
    owner => root,
    group => root,
    mode => '744',
  }

  file {'/etc/cron.hourly/zfs_receive_h2':
    ensure => link,
    target => '/usr/local/sbin/zfs_receive_h2',
  }
}
