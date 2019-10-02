## Rancher EBS

### Changelog - 0.6.1

#### Rancher EBS [rancher/storage-ebs:v0.9.8]
 * Addressed the issue where if all device paths were used on an ec2 instance, then ebs volumes would be spawned in a detached state in a perpetual loop.

### Restrictions when using EBS

An AWS EBS volume can only be attached to a single AWS EC2 instance. Therefore, all containers using the same AWS EBS volume will be scheduled on the same host.

[Read more about how to use EBS](http://rancher.com/docs/rancher/v1.6/en/rancher-services/storage-service/rancher-ebs/)
