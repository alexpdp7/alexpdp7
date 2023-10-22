class ipsilon($session_timeout_minutes = 30) {
  package {['ipsilon-tools-ipa', 'ipsilon-openidc']:}
  ->
  file {'/etc/ipsilon/root/ipsilon.conf':
    content => @("EOT")
      [global]
      debug = False
      tools.log_request_response.on = False
      template_dir = "templates"
      cache_dir = "/var/cache/ipsilon"
      cleanup_interval = 30
      db.conn.log = False
      db.echo = False

      # base.mount = ""
      base.dir = "/usr/share/ipsilon"
      admin.config.db = "sqlite:////var/lib/ipsilon/root/adminconfig.sqlite"
      user.prefs.db = "sqlite:////var/lib/ipsilon/root/userprefs.sqlite"
      transactions.db = "sqlite:////var/lib/ipsilon/root/transactions.sqlite"

      tools.sessions.on = True
      tools.sessions.name = "root_ipsilon_session_id"
      tools.sessions.storage_type = "file"
      tools.sessions.storage_path = "/var/lib/ipsilon/root/sessions"
      tools.sessions.path = ""
      tools.sessions.timeout = $session_timeout_minutes
      tools.sessions.httponly = True
      tools.sessions.secure = True
      | EOT
    ,
  }
  ~>
  service {'httpd':
    ensure => running,
    enable => true,
  }
}
