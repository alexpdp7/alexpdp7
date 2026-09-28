class tvheadend {
    file {'/usr/share/keyrings/tvheadend-tvheadend-archive-keyring.gpg':
      content => @(EOT)
      -----BEGIN PGP PUBLIC KEY BLOCK-----
      Version: GnuPG v2

      mQGNBGB4yfgBDADjHR6tQXqsBpDeIj4BeS6xgfHbCD2cdwgbPSlNQmCd00midw7Q
      XIh2rlWyZ2ko4KbmI9k01qXZ1dRsP09eIECE8LWUYw9qLWp3DD6VhIrLIAy5f611
      u2rWlwpTRRnsLmz4lAJu4NWT0nbddUSswrazOsjXwR0LZ/T7dpBltsj8dpXCWwli
      UZ/roPrOyc7uhTTwSLhc9tRrHkemRusN+K5V69ygjVu1xpDlFmfFYQvvqKJtVNsK
      pNrPlENAH6glaCWNphfzE0e+PHa6WplmGo2a90iWnFNAZkFVS6xpy3fF1Y9ioZcl
      Q6Kp8I3iDlcNN0WVf+XYQO+EnLxzLtWgMwafff0O6ned+6PGeQjC/6t7aNHmHAyw
      +aldpgTLlOHu4Wcz25miBJt+FTXZ5/QjgK62n3pD/oQ+aV600227jdxjsA3QJ790
      iwfMchYxfy1x+LAUqbB4iYk3DTY7i7jVfGVNgfiE3+Q1pnoGiYVy1cOyMfeREjOu
      kU9ITPBjXjSmj2UAEQEAAbRAQ2xvdWRzbWl0aCBQYWNrYWdlICh0dmhlYWRlbmQv
      dHZoZWFkZW5kKSA8c3VwcG9ydEBjbG91ZHNtaXRoLmlvPokBtwQTAQgAIQUCYHjJ
      +AIbLwULCQgHAwUVCgkICwUWAgMBAAIeAQIXgAAKCRDGzAa9abQwxiXYC/9DNDuC
      yNBY0dY9vJBdSlolrYZOIY8+0e/V20tnu35PZ6g66iLDmQdTBgIgrbleX1xT04mK
      x4NrNgVLs2otvThvMkUYN3i371daRlfQZs7LQI6CX1Gbm/LkbvihI2bG8z3Fnz5H
      6iRPPiA9ZqKX8j0MbBvy3eAXiIh6jcPlsT17ARfwkNMyI2RqODaO3j8l2PE+pj7B
      lGDhKhs/q5HnZZ7LtDZy6G1Ilzlu9AErmfydZH5sWgzTWn/PKoHPwG1B3JPEhlYK
      W4qj6dBhiCVWMqdoeXXYH/00iQbxppK77U7NMapkvih8fX9Gaculht792vShy+80
      9P4hYMyJ7eEAmxso//MIGdi5p/dOHVVVYa67/IqjosXXQhQaKSrjEwnR4dx74PWm
      1F7BhKmJB4exPiDThKcJGr+KiwickDI2i+rSUd9nqGjew34uQkBT7J9TFRd2cP0O
      VcfFM9CMGueFrknbclKSibJqne/J916+wvfZifdDbjBwjPpTvnp0HJLRtA0=
      =QBr4
      -----END PGP PUBLIC KEY BLOCK-----
      | EOT
      ,
    }
    ~>
    Exec["/usr/bin/apt update"]

    file {'/etc/apt/sources.list.d/mozilla.list':
      content => @(EOT)
      deb [signed-by=/usr/share/keyrings/tvheadend-tvheadend-archive-keyring.gpg] https://dl.cloudsmith.io/public/tvheadend/tvheadend/deb/debian trixie main
      | EOT
      ,
    }
    ~>
    Exec["/usr/bin/apt update"]
    ->
    package {'tvheadend':}

    # TODO: initial users are set up using debconf
}
