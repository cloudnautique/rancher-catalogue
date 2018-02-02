## Network Services for windows

This stack provides the following services:

* Metadata
* DNS

#### Metadata [rancher/metadata-windows:v0.10.0]
* Use microsoft/nanoserver as base image and rebuild metadata service.

#### DNS [rancher/dns-windows:v0.17.0]
* Use microsoft/nanoserver as base image and rebuild DNS service.
* In Windows environment, DNS server address will be 169.254.169.251

### Configuration Options

#### dns

* `DNS_RECURSER_TIMEOUT`
* `TTL`
