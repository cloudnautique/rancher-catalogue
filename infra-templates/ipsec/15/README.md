## IPSec Networking

Rancher networking plugin using IPsec.

### Open Ports

Traffic to and from hosts require UDP ports `500` and `4500` to be open.

### Changelog - 0.2.2

#### Router and CNI Driver [rancher/net:v0.13.7]
* Introduced connectivity check for ipsec.
* Fixed an issue where scheduler IPs could be picked up as the IP for the ipsec service for ports `500` and `4500`, which would cause cross host communication to no longer work for that host

### Configuration options
* `RANCHER_DEBUG`

#### ipsec

* `IPSEC_REPLAY_WINDOW_SIZE`
* `IPSEC_IKE_SA_REKEY_INTERVAL`
* `IPSEC_CHILD_SA_REKEY_INTERVAL`

#### cni-driver

* `DOCKER_BRIDGE`
* `MTU`
* `SUBNET`
* `RANCHER_HAIRPIN_MODE`
* `RANCHER_PROMISCUOUS_MODE`
* `HOST_PORTS`
* `SUBNET_PREFIX`
