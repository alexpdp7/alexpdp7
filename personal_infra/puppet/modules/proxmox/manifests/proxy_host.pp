define proxmox::proxy_host (String[1] $target) {
  file {"/etc/apache2/sites-enabled/$title.conf":
    content => @("EOT")
      MDomain $title

      <VirtualHost *:443>
        ServerName $title
        SSLEngine on

        ProxyPass "/" "$target"
        ProxyPassReverse "/" "$target"
        ProxyPreservehost On
        SSLProxyEngine on

      </VirtualHost>
    | EOT
    ,
  }
  ~>
  Service['apache2']
}
