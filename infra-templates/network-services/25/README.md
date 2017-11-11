## Network Services

This stack provides the following services:

* Metadata
* DNS
* Network Manager

### Changelog for v0.2.7

#### Network Manager [rancher/network-manager:v0.7.18]
* Fixed an issue with cni driver services during upgrade.
* Fixed incorrect network modes when rancher label is used.
* Fixed iptables rules reordering issue after docker daemon restart.
* Added ability to log message if MTU mismatch is found.
* Added support for other network plugins.
* Option to disable CNI setup.
* Added ability to disable various syncs available.
* Added ability to avoid adding rancher internal search domains if "io.rancher.container.dns.priority" is None.
* Updated to include `stopping` containers when establishing ipsec tunnels.


#### Metadata [rancher/metadata:v0.9.5]

### Configuration Options
* Introduces cpu_quota/cpu_limit to limit CPU resources for metadata container
* Support for metadata config reload throttling

#### dns

* `DNS_RECURSER_TIMEOUT`
* `TTL`

#### metadata

* `CPU_PERIOD`
* `CPU_QUOTA`
* `RELOAD_INTERVAL_LIMIT`
