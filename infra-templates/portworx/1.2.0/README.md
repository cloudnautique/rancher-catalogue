# Volume plugin for Portworx

Connect Portworx Hyper-converged Elastic Fabric to Cattle in Rancher!

This plugin enables both provisioning and management of storage resources. Deploying this service will maintain an instance of the plugin on each of the hosts in the environment.

Portworx is an elastic data fabric that runs hyperconverged with containers. 

Portworx fingerprints devices in a server, tiers based on drive capabilities, and aggregates capacity across multiple servers.

Portworx deploys as a container, and so it can run on baremetal Linux nodes, VMs or any cloud server.

Users run Portworx to get cloud-neutral elastic storage capacity, and high-availability at the container-level.

For more information about the plugin, see the [Portworx Docs](https://docs.portworx.com).

### Supported storage platforms
Portworx Elastic Data Fabric for Containers.

### Supported hosts
* RHEL / CentOS
* Ubuntu / Debian
* CoreOS

### Configured hosts
Each host must contribute one non-root volume or partition to the Global Pool.

