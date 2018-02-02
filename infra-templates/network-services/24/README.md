## Network Services

This stack provides the following services:

* Metadata
* DNS
* Network Manager

### Changelog for v0.2.6

#### DNS [rancher/dns:v0.15.3]
* Fix to honor upstream TTL
* Fix nil pointer cache
* Check locally before searching in global cache

#### Metadata [rancher/metadata:v0.9.4]
* Fix for go panic during json encoding

#### Network Manager [rancher/net:v0.7.8]
* Added support to inject dynamic values for CNI config
* Fixed start up error when CNI binary is a directory
* Moved some of the logging statements to debug level

### Configuration Options

#### dns

* `DNS_RECURSER_TIMEOUT`
* `TTL`
