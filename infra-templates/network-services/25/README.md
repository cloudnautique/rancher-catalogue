## Network Services

This stack provides the following services:

* Metadata
* DNS
* Network Manager

### Changelog for v0.2.7

#### Network Manager [rancher/network-manager:v0.7.13]
* Fixes iptables rules reordering issue after docker daemon restart.
* Ability to log message if MTU mismatch is found.
* Added support for other network plugins.
* Option to disable CNI setup.
* Ability to disable various syncs available.
* Added ability to avoid adding rancher internal search domains if "io.rancher.container.dns.priority" is None.
* Including stopping containers for haproxy drain feature.

### Configuration Options

#### dns

* `DNS_RECURSER_TIMEOUT`
* `TTL`
