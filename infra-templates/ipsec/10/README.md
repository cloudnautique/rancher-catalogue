## IPSec Networking

Rancher networking plugin using IPsec.

### Open Ports

Traffic to and from hosts require UDP ports `500` and `4500` to be open.

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

This version removes the `cni-driver` service as a sidekick of the `ipsec` container and makes it standalone.

###### [rancher/net:v0.11.4]
* This image version doesn't have any specific changes for IPSec but the programming logic for VXLAN has been improved.

