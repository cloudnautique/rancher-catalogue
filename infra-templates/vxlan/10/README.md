## VXLAN Networking

Rancher networking plugin using VXLAN overlay.

### Open Ports

Traffic to and from hosts requires UDP port `4789` to be open.

### Changelog - 0.2.0

The earlier version of this stack would cause a traffic disruption during upgrades, this version address to solve this problem. Also this version removes the `cni-driver` service as a sidekick of the `vxlan` container and makes it standalone.

#### Router and CNI Driver [rancher/net:v0.11.5]
* Addresses issue where stopped containers were considered as peers.
* This image has improved the programming logic for VXLAN to handle upgrade/restart scenarios gracefully without any traffic disruption.
* Fixed an issue where custom subnets were forcing `/16`

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
