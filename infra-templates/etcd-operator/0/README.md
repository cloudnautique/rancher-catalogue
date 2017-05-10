etcd-operator
=============

## Environment Mode

If no Rancher credentials are provided, Operator will manage etcd clusters for the environment it belongs to.

## Global Mode

**Experimental, use at your own risk.**

Provide an `Account` API Access Key, Secret Key and URL. Operator will manage etcd clusters across all environments.

### Limitations
The operator container will need direct network access to all etcd containers. This may be difficult to achieve across environments.

