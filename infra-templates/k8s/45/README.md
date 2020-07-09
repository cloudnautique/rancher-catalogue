## Kubernetes v1.10.0

### Software Versions

* Kubernetes v1.10.0
* Etcd v2.3.7

### Upgrading to this Version

Warning: The existing template version _must be_ `v1.2.4-rancher9` or later. Ignoring this will result in data loss. For older templates, please first upgrade to `v1.5.4-rancher1`.

Warning: If you are using the `aws` cloud provider, tagging your cluster resources with a `ClusterID` is required in Kubernetes v1.10. This needs to be done before upgrading. Please refer to the [documentation](https://rancher.com/docs/rancher/v1.6/en/kubernetes/providers/#configuring-the-clusterid) on how to tag your cluster resources.

Warning: If you are upgrading to this version from a version lower than `v1.9.5-rancher1-3`, it's possible to hit an issue with kubelet failing to start after the upgrade. To work around this issue, run the following commands on the hosts:
```bash
mount -o rw,remount /sys/fs/cgroup
mount --bind /sys/fs/cgroup/cpu,cpuacct/ /sys/fs/cgroup/cpuacct,cpu/
mount --bind /sys/fs/cgroup/net_cls,net_prio/ /sys/fs/cgroup/net_prio,net_cls/
```
This issue is resolved in Rancher `v1.6.19` with Kubernetes `v1.10.5`.

### Changelog for Kubernetes v1.10.0

* Updated for the latest Kubernetes release.

### Required Open Ports on hosts

 The following TCP ports are required to be open for `kubectl`: `10250` and `10255`. To access any exposed services, the ports used for the NodePort will also need to be opened. The default ports used by NodePort are TCP ports `30000` - `32767`.

### Plane Isolation

If you want to separate the planes for resiliency by labeling your hosts to separate out the data, orchestration and compute planes, you **must** change the plane isolation option to `required`. The host labels, `compute=true`, `orchestration=true` and `etcd=true`, are required on your hosts in order for Kubernetes to successfully launch. By default, `none` is selected and there will be no attempt for plane isolation.

### KubeDNS

KubeDNS is enabled for name resolution as described in the [Kubernetes DNS docs](http://kubernetes.io/docs/admin/dns/). The DNS service IP address is `10.43.0.10` by default.

### Audit Logs

Audit logs can be enabled through a simple option when deploying kubernetes, it will redirect all the Audit logs to the standard output for the kubernetes api container.

### Using in a proxy environment

By setting the HTTP_PROXY parameter, the `HTTP_PROXY`, `HTTPS_PROXY` and `NO_PROXY` environment variables will be added to the kubernetes containers.

### Azure Cloud provider support

The native Kubernetes Azure cloud provider is now enabled in this template. Currently, Azure Load Balancers, Azure Files, Azure Blob and Managed disks are supported for appropriate VM types.

It's possible to use Rancher-Machine-provisioned hosts or custom hosts created on Azure. Only hosts in the same resource group are currently supported. Also, for Azure Load Balancer to work, hosts that are expected to be in the Load balancer pool should be in the configured `Security Group`.

The following parameters are required to use the Azure Cloud Provider:
* **Azure Cloud Environment:** Select one of the available Azure Cloud Environments.
* **Azure Tenant ID**: In your Azure Portal, go to `Azure Active Directory` and select `properties`. Your `Directory ID` is your `Tenant ID`. Also, you can run the command `az account show` in your Azure Shell to get the same information.
* **Azure Client ID**: You can use the the procedure [here](http://rancher.com/docs/rancher/latest/en/hosts/azure/#app-registration) to create an App Registration.
* **Azure Client Secret:** Created as part to the App Registration procedure.
* **Azure Security Group:** Custom Azure Security Group needed to allow Azure Load Balancers to work. If you provision hosts using Rancher Machine Azure driver, you will need to edit them manually to assign them to this Security Group.
