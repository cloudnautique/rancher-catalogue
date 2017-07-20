## VXLAN Networking

Rancher networking plugin using VXLAN overlay.

### Open Ports

Traffic to and from hosts requires UDP port `4789` to be open.

#### Usage

##### Configuration options
* `RANCHER_DEBUG`

###### [cni-driver]

* `DOCKER_BRIDGE`
* `MTU`
* `SUBNET`
* `RANCHER_HAIRPIN_MODE`
* `RANCHER_PROMISCUOUS_MODE`
* `HOST_PORTS`
* `SUBNET_PREFIX`

#### Changelog

##### 0.1.2

The earlier version of this stack would cause a traffic disruption during upgrades, this version address to solve this problem. Also this version removes the `cni-driver` service as a sidekick of the `vxlan` container and makes it standalone.

###### [rancher/net:v0.11.4]
* This image has improved the programming logic for VXLAN to handle upgrade/restart scenarios gracefully without any traffic disruption.

