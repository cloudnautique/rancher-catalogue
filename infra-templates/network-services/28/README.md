## Network Services

This stack provides the following services:

* Metadata
* DNS
* Network Manager

### Changelog for v0.2.9

#### Metadata [rancher/metadata:v0.10.2]
* Small bug fixes

#### DNS [rancher/dns:v0.17.3]
* Small bug fixes

#### Network Manager [rancher/network-manager:v0.7.20]
* Fixed an issue where during startup of healthcheck, it is not able to reach server.
* Fixed an issue with deletiion of conntrack entries related to kubernetes cluster IP subnet.

### Configuration Options

#### dns

* `DNS_RECURSER_TIMEOUT`
* `TTL`

#### metadata

* `CPU_PERIOD`
* `CPU_QUOTA`
* `RELOAD_INTERVAL_LIMIT`
