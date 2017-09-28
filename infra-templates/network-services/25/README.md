## Network Services

This stack provides the following services:

* Metadata
* DNS
* Network Manager

### Changelog for v0.2.7

#### Network Manager [rancher/network-manager:v0.7.10]
* Added support for other network plugins.
* Dynamic value injection support in CNI config.
* Added options to disable various internal features.
* Added ability to avoid adding rancher internal search domains if "io.rancher.container.dns.priority" is None.

### Configuration Options

#### dns

* `DNS_RECURSER_TIMEOUT`
* `TTL`
