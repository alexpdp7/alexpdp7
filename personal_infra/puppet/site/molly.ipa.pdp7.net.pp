node 'molly.ipa.pdp7.net' {
  class {'workstation':}
  class {'steam':}
  package {['nextcloud-desktop', 'libusb-1.0-0-dev']:}
}
