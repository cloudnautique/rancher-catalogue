## Aliyun SLB External LB Service

### About SLB
Please check the official [document](https://www.aliyun.com/product/slb)

### About this service
Load balance Rancher services using SLB.
This service keeps existing SLB load balancers updated with the ECS instances on which Rancher services that have one or more exposed ports and the label `io.rancher.service.external_lb.endpoint` are running on.

### Usage

1. Deploy this stack
2. Using the SLB Console create a SLB load balancer with one or more listeners and configure it according to your applications requirements. Configure the listener(s) with an instance protocol and port matching that of the Rancher service that you want to forward traffic to.
3. Create or update your service to expose host ports that match the configuration of the SLB listener(s). Add the service label `io.rancher.service.external_lb.endpoint` using as value the name of the SLB load balancer you created.

> **NOTE** The front end ports of the SLB listener need to be consistent with the exposed ports on the host.
