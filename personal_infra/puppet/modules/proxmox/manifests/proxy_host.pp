define proxmox::proxy_host (String[1] $target, Optional[String[1]] $overwrite_rh_certs = undef) {
  if $target =~ /^https:/ {
    $ssl_fragment = @("EOT")
      SSLEngine on
      SSLProxyEngine on
      SSLProxyCheckPeerName off
    | EOT
  }
  else {
    $ssl_fragment = ""
  }

  file {"/etc/apache2/sites-enabled/$title.conf":
    content => @("EOT")
      MDomain $title

      <VirtualHost *:443>
        ServerName $title

        ProxyPass "/" "$target"
        ProxyPassReverse "/" "$target"
        ProxyPreservehost On
        $ssl_fragment
      </VirtualHost>
      | EOT
    ,
  }
  ~>
  Service['apache2']

  if $overwrite_rh_certs {
    $pveid = lookup("hostvars.'$overwrite_rh_certs'.proxmox.id");

    file {"/usr/local/bin/notify_md_renewal_hook_$overwrite_rh_certs":
      content => @("EOT"/$)
      #!/bin/sh

      cp /etc/apache2/md/domains/$title/pubcert.pem  /rpool/data/subvol-$pveid-disk-0/etc/pki/tls/certs/localhost.crt
      cp /etc/apache2/md/domains/$title/privkey.pem  /rpool/data/subvol-$pveid-disk-0/etc/pki/tls/private/localhost.key
      pct exec $pveid systemctl restart httpd
      | EOT
      ,
      mode => '0755',
    }
  }


}
