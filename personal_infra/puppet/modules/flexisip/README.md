# Flexisip

## Baresip configuration

* account: `sip:ext@sip.pdp7.net;transport=tls`
* password: ...
* out proxy: `sip:sip.pdp7.net;transport=tls`
* sip provider: `sip.pdp7.net`

Ensure that certificate verification is disabled.
Certificate verification might show as disabled when it is enabled.

## Grandstream HT801 configuration

This configuration does not set a persistent registration database.
When Flexisip restarts, registered devices do not work correctly until reregistered.

For the Grandstream HT801, in "FXS Port", set "Enable SIP OPTIONS/NOTIFY Keep Alive" to "NOTIFY".
The default parameters reregister in 90 seconds.
