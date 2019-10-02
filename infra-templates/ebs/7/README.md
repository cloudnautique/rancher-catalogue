## Rancher EBS

### Changelog - 0.6.0

#### Rancher EBS [rancher/storage-ebs:v0.9.7]
 * Added support for volume partitions
 * Added ability to specify snapshot by tag key and value pair

### Restrictions when using EBS

An AWS EBS volume can only be attached to a single AWS EC2 instance. Therefore, all containers using the same AWS EBS volume will be scheduled on the same host.

[Read more about how to use EBS](http://rancher.com/docs/rancher/v1.6/en/rancher-services/storage-service/rancher-ebs/)
