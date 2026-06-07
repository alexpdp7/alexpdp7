class autokey {
  file {'/etc/apt/keyrings/autokey.asc':
    content => @(EOT)
    -----BEGIN PGP PUBLIC KEY BLOCK-----
    mQINBGP+JTIBEADgfRYWr3GrFdy6q0ih4RTkNBX48mcA7+oECJppB/m2cViZjd3C
    kg7bnn91oBG3ajQF1EnySEw3XSW5hHrx1AJ9nXBwhf8v28+eken+u0rPFxE3aPeI
    c2KDBNk905j8lGhd/VwdKuzZ8XkKh6Bhsl/x7peIvrGhZC1mco0OMw6mbPdTnsmS
    bavHjBmby0tUGf8rFo6IWs8TBRocVoSBrNWN1RQqsmeOOEQmJa9AMDBbRzDCJGXW
    HtM7kZydCQqc/bZbh+jI/WA+AUmGObcQaUzWRdmp37QiOCQe+3oHmBhcHsOTwpYm
    bKhdQ7Ylb1c7y2uihSjN5qzUmkjk97ReGkQvqSalCimQjalppDG/MaX9JaVMXHJU
    8V4Hb+cO6HWncfWlnEHvR4JWNaA4QgcQhL/+1gIJytXR/i7Dor0lETNxkBng53RW
    uS7xi1MqVV6ao8nJ+u4I7nnQ/77RNQT9iPGjwHclXPG+aweQ9jcwlDVD5rB6uG9b
    Aa9nQuO5zZEAVOr/EL4y1OKLsPxsRcBPUuSwcveGwvSEqOTTIZhqa9KJH8WowSDq
    52ZwCZNvGG6iupS5A8/auSN4xM8ia5PGqTgjZJtop6wPGOu4G2uVpyxh8PYjEcx7
    7tgy3hXMVmgnQzhCLRtfleZAoduBXjILO+v87H/cUbGqLb7DoG4PfWA2DwARAQAB
    tCx1ZG0taGFja3MtcmVwbyA8dWRtLWhhY2tzLXJlcG9AZGF2ZWtpbmcuY29tPokC
    UQQTAQgAOxYhBMgVHx0wDji86QcLSzySDVhUVnFNBQJj/iUyAhsvBQsJCAcCAiIC
    BhUKCQgLAgQWAgMBAh4HAheAAAoJEDySDVhUVnFNw4IP/jtu4fDYQjOJLMSr+S2B
    dndLHi6UYYssi6JarfMXfmhhPQXHQov2A/o8XB1rYw9nGvgEAN/+dv3GJFpAYHKH
    iAUyjgZFXDDC+phmQBXtJ8Ko49+qZ+WejybnxbfdngjpEbiYt5JxDrD38v7siSnh
    wuep1Iq7zWaV2LUgIbhO32EqeRlpEOr+q7a+EAxU8hxeiOv3k2OM6VcrS4ElaUTD
    gdAraYg83ysdGqWM4CIUJiyNO8yu1eVhWOfVtGXoQPPljIpqCelmJ2AJS4foot+F
    mV2FcFDsXHdVi6xk6KdndRIwsvGzrQty1gU4DioZYozJHocWhCJx3JIDF4+yrONb
    x0oPNLyTYg/oZrv3QMzMXp7auATSXQGqOO7SvBafxYHSpQYsxCPHYPEou9evafax
    BvYo7cjzTt8cQlwnEuOsapvbz6T+eceFnzch31FMe1f//qVogpGyYUVA5xR1voce
    FL2aXlb7qPY24D+UZEFlFzCzmiMJXooIZMrBzWFD4Vzu9Dmax3tw7qfKN3SUp6no
    KdujvysUcD2118WyFteP22XcMGjNAnDMp3dNAq5TV0+26/togdAM/PTXRuhXq5cs
    yF/N7caH7C1HHmSl1ntAiUqk7fJJEtIWf7WnT2n9OZO1SO46UHozXy8Y1d4DC32t
    hLGDcYe5T4CgeTByfoy5pUV6
    =Ef6N
    -----END PGP PUBLIC KEY BLOCK-----
    | EOT
    ,
  }
  ~>
  Exec['/usr/bin/apt update']

  file {'/etc/apt/sources.list.d/autokey-wayland-ppa.list':
    content => @(EOT)
    deb [signed-by=/etc/apt/keyrings/autokey.asc] https://daveking.com/autokey-wayland-ppa ./
    | EOT
    ,
  }
  ~>
  Exec['/usr/bin/apt update']

  Exec['/usr/bin/apt update']
  ->
  package {'autokey-gtk':}
}
