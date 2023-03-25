# Talos Ansible role

This role helps provision Talos clusters using Ansible.
Currently, this role only supports VMs on Proxmox and single node clusters.

## Variables

### Host variables

```
proxmox:
  id: 123
  host: inventory_name_of_proxmox_host
  cores: n
  memory: in MB
  disk: in GB
network:
  ip: x.y.z.t
talos_host:
  talos_cluster: cluster_name
  install_disk: /dev/vda
```

### Group variables

```
talos_clusters:
  cluster_name: # you can have multiple clusters
    endpoint: https://host_name:6443
```

## Talos configuration

Only the Talos secret for the cluster must be stored in version control.
You must create the secret and vault it:

```
$ talosctl gen secrets -o talos/${cluster_name}-secrets.yaml
$ ansible-vault encrypt talos/${cluster_name}-secrets.yaml
```

## Role

With the above configuration, the role will:

* Create the VM in Proxmox.
Until Talos includes https://github.com/siderolabs/talos/pull/5897 , [the playbook fishes the IP from the dnsmasq Proxmox instance](tasks/proxmox.yml#L13) by using [this script](files/get-ip).
* Sets up Talos.
* Fetches the kubeconfig.
* Deploys kustomizations in `k8s/base`. 
See [my kustomizations](../../../k8s/base/).
