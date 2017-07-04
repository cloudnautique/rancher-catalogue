# Volume plugin for SolidFire

Connect your NetApp SolidFire systems to Cattle in Rancher!

This plugin enables both provisioning and management of storage resources. Deploying this service will maintain an instance of the plugin on each of the hosts in the environment.

For more information about the plugin, see the [GitHub repository](https://github.com/NetApp/netappdvp).

### Supported storage platforms
Any NetApp SolidFire system.

### Supported hosts
* RHEL / CentOS
* Ubuntu / Debian

### Configured hosts
Each host requires an iSCSI initiator. See the plugin's [iSCSI installation guide](https://github.com/NetApp/netappdvp#iscsi) for more details.
