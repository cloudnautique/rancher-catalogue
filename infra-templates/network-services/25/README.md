## Network Services

This stack provides the following services:

* Metadata
* DNS
* Network Manager

### Changelog for v0.2.7

#### Network Manager [rancher/net:v0.7.9]
* Added ability to avoid adding rancher internal search domains if "io.rancher.container.dns.priority" is None.

### Configuration Options

#### dns

* `DNS_RECURSER_TIMEOUT`
* `TTL`
