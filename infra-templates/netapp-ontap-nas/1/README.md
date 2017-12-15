# Volume plugin for ONTAP

Connect your NetApp ONTAP systems to Cattle in Rancher!

This plugin enables both provisioning and management of storage resources. Deploying this service will maintain an instance of the plugin on each of the hosts in the environment.

For more information about the plugin, see the [GitHub repository](https://github.com/NetApp/netappdvp).

### Supported storage platforms
Any NetApp ONTAP system with NFS enabled.

### Supported hosts
* RHEL / CentOS
* Ubuntu / Debian

### Configured hosts
Each host requires an NFS client. See the plugin's [NFS installation guide](https://github.com/NetApp/netappdvp#nfs) for more details.
