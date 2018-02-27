## Kubernetes 1.5.8

### Required Open Ports on hosts

The following TCP ports are required to be open for `kubectl`: `10250` and `10255`. To access any exposed services, the ports used for the NodePort will also need to be opened. The default ports used by NodePort are TCP ports `30000` - `32767`.

### Private Registry for Pod Infra Container Image and Add-ons

The private registry field populates which private registry the pod infra container image should be pulled from as well as the add-ons.

**Do not put the private registry in the `Pod Infra Container Image` field**.

### Plane Isolation

If you are trying to create resiliency planes by labeling your hosts to separate out the data, orchestration and compute planes, you **must** change the plane isolation option to `required`. The host labels, `compute=true`, `orchestration=true` and `etcd=true`, are required on your hosts in order for Kubernetes to successfully launch. By default, `none` is selected and there will be not attempt for plane isolation.

#### Upgrading Kubernetes and Requiring Plane Isolation

If you choose `required` for plane isolation and have a previous installation of Kubernetes, your `etcd=true` labels **must** be on the hosts that have the etcd service running on it.

### KubeDNS

KubeDNS is enabled for name resolution as described in the [Kubernetes DNS docs](http://kubernetes.io/docs/admin/dns/). The DNS service IP address is `10.43.0.10`.
