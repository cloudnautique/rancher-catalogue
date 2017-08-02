## Network Services

This stack provides the following services:

* Metadata
* DNS
* Network Manager

### Changelog for v0.2.4

Default timeout for internal Rancher DNS was updated from 10 seconds to 1 second.

#### Network Manager [rancher/network-manager:v0.7.7]
* Fixes the conntrack, arpsync logic to take action on only running and starting containers.
* Fixes the logic of figuring out local networks in an environment to support different CNI plugins.

### Configuration Options

#### dns

* `DNS_RECURSER_TIMEOUT`
* `TTL`
