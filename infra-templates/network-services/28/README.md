## Network Services

This stack provides the following services:

* Metadata
* DNS
* Network Manager

### Changelog for v0.2.10

#### Network Manager [rancher/network-manager:v0.7.21]
* Fixed an issue with iptables rules when accessing expose port from self host.

### Configuration Options

#### dns

* `DNS_RECURSER_TIMEOUT`
* `TTL`

#### metadata

* `CPU_PERIOD`
* `CPU_QUOTA`
* `RELOAD_INTERVAL_LIMIT`
