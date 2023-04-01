# Podman

You can create LXC containers in Proxmox (using ZFS) that can run rootless Podman.

The [`proxmox_create_lxc`](playbooks/roles/proxmox_create_lxc/) role can create the LXC container with the necessary options with the following configuration:

```
proxmox:
...
  privileged: true
  features: fuse=1,nesting=1
  extra:
    - "lxc.mount.entry: /dev/net/tun dev/net/tun none bind,create=file"
    - "lxc.cgroup2.devices.allow: c 10:200 rwm"
```

The [`podman`](puppet/modules/podman/) Puppet module can add the necessary configuration:

```
class {'podman':
  user => 'your_username',
  storage_driver => 'zfs',
}
```

This module configures subuids/subgids, but until you reboot, you will get some warnings using Podman.
