## Network Services

This stack provides the following services:

* Metadata
* DNS
* Network Manager

### Changelog for v0.2.5

#### Metadata [rancher/rancher-metadata:v0.9.3]
* Fixes around decoding delta when reading from file and event stream

#### DNS [rancher/dns:v0.15.1]
* Uses a fixed listen address of 169.254.169.250, instead of all available IP addresses.

### Configuration Options

#### dns

* `DNS_RECURSER_TIMEOUT`
* `TTL`
