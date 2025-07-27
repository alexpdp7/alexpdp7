$ipa_client_package = case $facts['os']['family'] {
  'Debian': { 'freeipa-client' }
  'RedHat': { 'ipa-client' }
  default: { fail($facts['os']['family']) }
}

if $facts['os']['family'] == 'Debian' and $facts['os']['release']['major'] == "12" {
  # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1026008
  service {['sssd-ssh.socket', 'sssd-pam-priv.socket', 'sssd-nss.socket', 'sssd-pam.socket', 'sssd-sudo.socket', 'sssd-pac.socket']:
    ensure => stopped,
    enable => mask,
  }
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
