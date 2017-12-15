## VXLAN Networking

Rancher networking plugin using VXLAN overlay.

### Open Ports

Traffic to and from hosts requires UDP port `4789` to be open.

### Changelog - v0.2.1

#### Router and CNI Driver [rancher/net:v0.11.9]
* Fixes the container fetch logic to address service upgrade issues.
* Use of rancher-metadata IP address to avoid name resolution
* Applies the provided MTU on the vtep interface as well

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
