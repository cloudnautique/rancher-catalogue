## Network Services

This stack provides the following services:

* Metadata
* DNS
* Network Manager

### Changelog for v0.2.6

#### DNS [rancher/dns:v0.15.2]
* Fix to honor upstream TTL
* Check locally before searching in global cache

### Configuration Options

#### dns

* `DNS_RECURSER_TIMEOUT`
* `TTL`
