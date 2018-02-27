## IPSec Networking

Rancher networking plugin using IPsec.

### Open Ports

Traffic to and from hosts require UDP ports `500` and `4500` to be open.

### Changelog - 0.1.3

#### Router and CNI Driver [rancher/net:v0.11.7]
* Address a problem with CNI driver where networking setup for a container fails.
* Fixes the container fetch logic to address service upgrade issues.

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
