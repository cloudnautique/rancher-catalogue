## IPSec Networking

Rancher networking plugin using IPsec.

### Open Ports

Traffic to and from hosts require UDP ports `500` and `4500` to be open.

### Changelog - 0.2.3

#### Router, CNI Driver, Connectivity Check [rancher/net:v0.13.11]
* Reduced the logging level for ipsec
* Fixing connectivity check issues when adding multiple hosts

### Configuration options
* `RANCHER_DEBUG`

#### ipsec

* `IPSEC_REPLAY_WINDOW_SIZE`
* `IPSEC_IKE_SA_REKEY_INTERVAL`
* `IPSEC_CHILD_SA_REKEY_INTERVAL`
* `RANCHER_IPSEC_PSK`

#### cni-driver

* `DOCKER_BRIDGE`
* `MTU`
* `SUBNET`
* `SUBNET_START_ADDRESS`
* `SUBNET_END_ADDRESS`
* `RANCHER_HAIRPIN_MODE`
* `RANCHER_PROMISCUOUS_MODE`
* `HOST_PORTS`
* `SUBNET_PREFIX`
