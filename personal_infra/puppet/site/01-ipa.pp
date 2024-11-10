$ipa_client_package = case $facts['os']['family'] {
  'Debian': { 'freeipa-client' }
  'RedHat': { 'ipa-client' }
  default: { fail($facts['os']['family']) }
}

if $facts['os']['family'] == 'Debian' and $facts['os']['release']['major'] == "11" {
  class {'debian::backports':}
  ->
  Package[$ipa_client_package]

  service {['sssd-pac.service', 'sssd-pac.socket']:
    ensure => stopped,
    enable => mask,
  }
}

# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1026008
if $facts['os']['family'] == 'Debian' and $facts['os']['release']['major'] == "12" {
  Package[$ipa_client_package]
  ->
  service {['sssd-ssh.socket', 'sssd-nss.socket', 'sssd-sudo.socket', 'sssd-pam-priv.socket']:
    ensure => stopped,
    enable => mask,
  }
  ~>
  Exec['/usr/bin/systemctl reset-failed']
}

package {$ipa_client_package:}
package {'sudo':}

if 'lxc' in lookup("group_names") {
  service {['var-lib-nfs-rpc_pipefs.mount', 'chronyd.service', 'sys-kernel-config.mount', 'sys-kernel-debug.mount', 'auth-rpcgss-module.service', 'rtkit-daemon.service', 'low-memory-monitor.service']:
    ensure => stopped,
    enable => mask,
  }
  ~>
  Exec['/usr/bin/systemctl reset-failed']
}

exec {'/usr/bin/systemctl reset-failed':
  refreshonly => true,
}
