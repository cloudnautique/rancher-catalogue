## VXLAN Networking

Rancher networking plugin using VXLAN overlay.

### Open Ports

Traffic to and from hosts requires UDP port `4789` to be open.

### Changelog - v0.3.1

#### Router [rancher/net:v0.11.9]
* Revert changes in vxlan v0.3.0 from using host network namespace.

#### CNI Driver [rancher/net:v0.13.1]
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
