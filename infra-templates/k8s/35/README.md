## Kubernetes v1.7.7

### Software Versions

* Kubernetes v1.7.7
* Etcd v2.3.7

### Upgrading to this Version

Warning: The existing template version _must be_ `v1.2.4-rancher9` or later. Ignoring this will result in data loss. For older templates, please first upgrade to `v1.5.4-rancher1`.

### Changelog for Kubernetes 1.7.7

* Updated for the latest DNS fixes (`k8s-dns-kube-dns-amd64:1.14.5`)
* Updated for an updated influxDB (`heapster-influxdb-amd64:v1.3.3`)

### Required Open Ports on hosts

 The following TCP ports are required to be open for `kubectl`: `10250` and `10255`. To access any exposed services, the ports used for the NodePort will also need to be opened. The default ports used by NodePort are TCP ports `30000` - `32767`.

### Plane Isolation

If you want to separate the planes for resiliency by labeling your hosts to separate out the data, orchestration and compute planes, you **must** change the plane isolation option to `required`. The host labels, `compute=true`, `orchestration=true` and `etcd=true`, are required on your hosts in order for Kubernetes to successfully launch. By default, `none` is selected and there will be no attempt for plane isolation.

### KubeDNS

KubeDNS is enabled for name resolution as described in the [Kubernetes DNS docs](http://kubernetes.io/docs/admin/dns/). The DNS service IP address is `10.43.0.10`.

### Audit Logs

Audit logs can be enabled through a simple option when deploying kubernetes, it will redirect all the Audit logs to the standard output for the kubernetes api container.
