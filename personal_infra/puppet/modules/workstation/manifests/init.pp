class workstation {
  package {['rclone', 'sshpass', 'python3-pip', 'xclip']:}

  if ($facts['os']['family'] == 'Debian') {
    # make nextcloud-desktop a separate class
    package {['nextcloud-desktop', 'gnome-shell-extension-appindicator']:}

    file {'/etc/apt/keyrings/packages.mozilla.org.asc':
      content => @(EOT)
      -----BEGIN PGP PUBLIC KEY BLOCK-----

      xsBNBGCRt7MBCADkYJHHQQoL6tKrW/LbmfR9ljz7ib2aWno4JO3VKQvLwjyUMPpq
      /SXXMOnx8jXwgWizpPxQYDRJ0SQXS9ULJ1hXRL/OgMnZAYvYDeV2jBnKsAIEdiG/
      e1qm8P4W9qpWJc+hNq7FOT13RzGWRx57SdLWSXo0KeY38r9lvjjOmT/cuOcmjwlD
      T9XYf/RSO+yJ/AsyMdAr+ZbDeQUd9HYJiPdI04lGaGM02MjDMnx+monc+y54t+Z+
      ry1WtQdzoQt9dHlIPlV1tR+xV5DHHsejCZxu9TWzzSlL5wfBBeEz7R/OIzivGJpW
      QdJzd+2QDXSRg9q2XYWP5ZVtSgjVVJjNlb6ZABEBAAHNVEFydGlmYWN0IFJlZ2lz
      dHJ5IFJlcG9zaXRvcnkgU2lnbmVyIDxhcnRpZmFjdC1yZWdpc3RyeS1yZXBvc2l0
      b3J5LXNpZ25lckBnb29nbGUuY29tPsLAjgQTAQoAOBYhBDW6oLM+nrOW9ZyoOMC6
      XObcYxWjBQJgkbezAhsDBQsJCAcCBhUKCQgLAgQWAgMBAh4BAheAAAoJEMC6XObc
      YxWj+igIAMFh6DrAYMeq9sbZ1ZG6oAMrinUheGQbEqe76nIDQNsZnhDwZ2wWqgVC
      7DgOMqlhQmOmzm7M6Nzmq2dvPwq3xC2OeI9fQyzjT72deBTzLP7PJok9PJFOMdLf
      ILSsUnmMsheQt4DUO0jYAX2KUuWOIXXJaZ319QyoRNBPYa5qz7qXS7wHLOY89IDq
      fHt6Aud8ER5zhyOyhytcYMeaGC1g1IKWmgewnhEq02FantMJGlmmFi2eA0EPD02G
      C3742QGqRxLwjWsm5/TpyuU24EYKRGCRm7QdVIo3ugFSetKrn0byOxWGBvtu4fH8
      XWvZkRT+u+yzH1s5yFYBqc2JTrrJvRU=
      =QnvN
      -----END PGP PUBLIC KEY BLOCK-----
      | EOT
      ,
    }
    ~>
    Exec["/usr/bin/apt update"]

    file {'/etc/apt/sources.list.d/mozilla.list':
      content => @(EOT)
      deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main
      | EOT
      ,
    }
    ~>
    Exec["/usr/bin/apt update"]

    Exec["/usr/bin/apt update"]
    ~>
    package {'firefox':}

    package {'firefox-esr':
      ensure => absent,
    }
  }
}
