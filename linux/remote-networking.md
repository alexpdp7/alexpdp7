# Remote networking

If you can create a pipe between two hosts (using SSH, for example), you can use VDE (Virtual Distributed Ethernet) to connect the two hosts over a virtual network.

You need the following programs on both hosts:

* `dpipe` and `vde_plug` (on Debian, use the `vdeplug` package)
* `vde-switch` (on Debian, use the `vde-switch` package)

Run `vde_switch -t tap0` as root on both hosts.
This command creates a virtual switch connected to `tap0`.

Use the `dpipe` command to connect two instances of the `vde_plug` command running as root on both hosts.

```console
$ dpipe sudo vde_plug = ssh root@remote vde_plug
```

Then bring the `tap0` interface up and configure IP addresses on both hosts.

```console
# ip link set tap0 up
# ip addr add $IP/$NETMASK dev tap0
```
