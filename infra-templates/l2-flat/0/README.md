## L2 Flat Networking

Rancher networking plugin using l2-flat.

### Requirements

L2 Flat is heavily dependent on the infrastructure network configuration, the public cloud can not use. 
The network of all Rancher-managed containers will be on the same Layer 2 network. Make sure the `FLAT_IF` is promiscuous mode.

### Usage

If you want to configure `FLAT_BRIDGE` yourself, please set `AUTO_SETUP_FLAT_BRIDGE` to false.

#### Configuration labels:

Optional:

- **io.rancher.network.l2flat.interface**

  The catalog option `FLAT_IF` is a generic configuration, and all hosts use it. You can set this host label to override `FLAT_IF`.

  *Example:* `io.rancher.network.l2flat.interface: ens3`

### Configuration options
* `RANCHER_DEBUG`
* `AUTO_SETUP_FLAT_BRIDGE`

#### cni-driver

* `FLAT_BRIDGE`
* `FLAT_IF`
* `MTU`
* `SUBNET`
* `START_ADDRESS`
* `END_ADDRESS`
* `GATEWAY`
