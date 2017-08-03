# Volume plugin for E-Series

Connect your NetApp E-Series systems to Cattle in Rancher!

This plugin enables both provisioning and management of storage resources. Deploying this service will maintain an instance of the plugin on each of the hosts in the environment.

For more information about the plugin, see the [GitHub repository](https://github.com/NetApp/netappdvp).

### Supported storage platforms
Any NetApp E-Series system with a web proxy, appropriate volume groups, and iSCSI enabled. See the nDVP's [E-Series array setup notes](https://github.com/NetApp/netappdvp#e-series-array-setup-notes) for more details.

### Supported hosts
* RHEL / CentOS
* Ubuntu / Debian

### Configuring hosts
Each host requires an iSCSI initiator and a multipathing daemon. See the plugin's [iSCSI installation guide](https://github.com/NetApp/netappdvp#iscsi) for more details.
