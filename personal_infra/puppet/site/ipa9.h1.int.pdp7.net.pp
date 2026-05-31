node 'ipa9.h1.int.pdp7.net' {
  class {'freeipa::server':}

  # $ sudo ipa-healthcheck
  # Can't find /proc/sys/crypto/fips_enabled, skipping
  # [
  #   {
  #     "source": "ipahealthcheck.meta.core",
  #     "check": "MetaCheck",
  #     "result": "WARNING",
  #     "uuid": "22485a2e-5931-4c2d-a72f-89616c34cbbe",
  #     "when": "20260531075056Z",
  #     "duration": "2.267750",
  #     "kw": {
  #       "key": "meta",
  #       "fqdn": "ipa9.h1.int.pdp7.net",
  #       "fips": "missing /proc/sys/crypto/fips_enabled",
  #       "acme": "disabled",
  #       "ipa_version": "4.13.1",
  #       "ipa_api_version": "2.257"
  #     }
  #   }
  # ]
  file {'/etc/ipahealthcheck/ipahealthcheck.conf':
    content => @("EOT")
    [default]

    [excludes]
    key=meta
    | EOT
    ,
  }
}
