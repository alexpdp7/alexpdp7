node 'julius.ces.int.pdp7.net' {
  # Raspberry Pi stuff; disable root
  file {'/etc/cloud/cloud.cfg':
    content => @("EOT")
    disable_root: false

    # This will cause the set+update hostname module to not operate (if true)
    preserve_hostname: false

    # If you use datasource_list array, keep array items in a single line.
    # If you use multi line array, ds-identify script won't read array items.
    # Example datasource config
    # datasource:
    #   Ec2:
    #     metadata_urls: [ 'blah.com' ]
    #     timeout: 5 # (defaults to 50 seconds)
    #     max_wait: 10 # (defaults to 120 seconds)

    # The modules that run in the 'init' stage
    cloud_init_modules:
      - seed_random
      - bootcmd
      - write_files
      - disk_setup
      - mounts
      - set_hostname
      - update_hostname
      - update_etc_hosts
      - ca_certs
      - rsyslog
      - users_groups
      - ssh
      - set_passwords

    # The modules that run in the 'config' stage
    cloud_config_modules:
      - ssh_import_id
      - keyboard
      - locale
      - ntp
      - timezone
      - raspberry_pi
      - disable_ec2_metadata
      - runcmd

    # The modules that run in the 'final' stage
    cloud_final_modules:
      - package_update_upgrade_install
      - write_files_deferred
      - puppet
      - chef
      - ansible
      - mcollective
      - salt_minion
      - reset_rmc
      - netplan_nm_patch
      - scripts_vendor
      - scripts_per_once
      - scripts_per_boot
      - scripts_per_instance
      - scripts_user
      - ssh_authkey_fingerprints
      - keys_to_console
      - install_hotplug
      - phone_home
      - final_message
      - power_state_change

    # System and/or distro specific settings
    # (not accessible to handlers/transforms)
    system_info:
      # This will affect which distro class gets used
      distro: raspberry-pi-os
      # Default user name + that default users groups (if added/used)
      network:
        renderers: ['netplan', 'network-manager']
        activators: ['netplan', 'network-manager']
      # If set to true, cloud-init will not use fallback network config.
      # In Photon and Raspberry Pi OS, we have default network settings,
      # hence if network settings are not explicitly given in metadata,
      # don't use fallback network config.
      disable_fallback_netcfg: true
      ntp_client: 'systemd-timesyncd'
      ssh_svcname: ssh

    hostname: julius
    fqdn: julius.ces.int.pdp7.net

    | - EOT
    ,
  }
}
