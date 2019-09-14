# Volume plugin for Portworx

This version of [Portworx](https://docs.portworx.com) stack will transparently download and install [Portworx runC container](https://docs.portworx.com/runc), which runs directly on the host as a service.

## Prerequisites

* **Key-value store**: Portworx uses a key-value store for it's clustering metadata. Please have a clustered key-value database (etcd or consul) installed and ready before starting the Portworx installation. For etcd installation instructions please refer to this [doc](https://docs.portworx.com/maintain/etcd.html).
* **Storage**: At least one of the Portworx nodes should have extra storage available, in a form of unformatted partition or a disk-drive.<br/>NOTE: Storage devices explicitly given to Portworx via `-s /dev/xxx` will be automatically formatted by PX.
* **Firewall**: Ensure ports 9001-9015 are open between the nodes that will run Portworx.
* **NTP**: Ensure all nodes running PX are time-synchronized, and NTP service is configured and running.
* **Hosts**: The systemd package should be installed and available on all host systems.  If your hosts are running Ubuntu 16, CentoOS 7 or CoreOS v94 (or newer) the “systemd” is already installed and no actions will be required.

## Installation

To install Portworx, please enter the "Configuration Options" below, and click on "Launch".

Please note that the Portworx will by default install as a [global service](http://rancher.com/docs/rancher/latest/en/cattle/scheduling/#global-service)
to *all Racher hoots* in your environment.  If you need to avoid installing Portworx on certain hosts, edit the individual Hosts using Rancher GUI via "INFRASTRUCTURE / Hosts / : / Edit", and attach the `px/enabled=false` label to the given host.

Please note that the "Configuration Options" below show only a minimum of customization options.  Refer to the [#command-line-arguments page](https://docs.portworx.com/runc/#command-line-arguments) page for the full set of supported options.  Extra options can be added "verbatim" into the `Extra Options` field below.

## Uninstallation

Please note that Rancher will forbid the uninstall of Portworx stack as long as there are any containers or volumes still present in Rancher environment.

If you want to completely remove the Portworx from Rancher, it will not be sufficient to remove only the Portworx stack, since Portworx OCI service will continue running on the host system as "systemd service".  To remove the Portworx software, including the Portworx systemd service, please run the following:

```
for id in $(rancher ps -q -s portworx/portworx); do
  rancher exec $id /px-rest-helper.sh remove
done
rancher rm -s portworx/portworx; sleep 5
rancher rm -s portworx
```
