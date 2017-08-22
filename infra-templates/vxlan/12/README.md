## VXLAN Networking

Rancher networking plugin using VXLAN overlay.

### Open Ports

Traffic to and from hosts requires UDP port `4789` to be open.

### Changelog - v0.2.2

#### Router and CNI Driver [rancher/net:v0.11.9]
* Let vtep interface MTU to be configurable

### Configuration options
* `RANCHER_DEBUG`
* `VXLAN_VTEP_MTU`

#### cni-driver

* `DOCKER_BRIDGE`
* `MTU`
* `SUBNET`
* `RANCHER_HAIRPIN_MODE`
* `RANCHER_PROMISCUOUS_MODE`
* `HOST_PORTS`
* `SUBNET_PREFIX`
