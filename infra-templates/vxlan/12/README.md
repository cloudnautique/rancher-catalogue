## VXLAN Networking

Rancher networking plugin using VXLAN overlay.

### Open Ports

Traffic to and from hosts requires UDP port `4789` to be open.

### Changelog - v0.3.0

The earlier version of this stack would cause a traffic disruption during upgrades, this version address to solve this problem. Also this version removes the `cni-driver` service as a sidekick of the `vxlan` container and makes it standalone.

#### Router and CNI Driver [rancher/net:v0.13.1]
* Refactored to run in host network ns for performance improvements.
* Updated to include `stopping` containers

### Configuration options
* `RANCHER_DEBUG`

#### cni-driver

* `DOCKER_BRIDGE`
* `MTU`
* `SUBNET`
* `RANCHER_HAIRPIN_MODE`
* `RANCHER_PROMISCUOUS_MODE`
* `HOST_PORTS`
* `SUBNET_PREFIX`
