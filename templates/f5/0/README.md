external-lb
==========
Rancher service facilitating integration of rancher with f5 BIG-IP - external load balancer. This service updates f5 with services created in Rancher that ask to be load balanced using f5. 
Initial version comes with support for an unpartitioned f5 BIG-IP installation

Design
==========
* The f5 service gets deployed as a Rancher service containerized app. 

* It enables any other service to be registered to external f5 if the service has exposed a public port and has the label 'io.rancher.service.external_lb_endpoint'

* Value of this label should be equal to the VirtualServer Name on f5 BIG-IP

* The VirtualServer should be pre-configured on f5

* The rancher hosts on which the containers of the service are running, will be added to the f5 setup as nodes

* A new f5 pool will be created for the service, having the Rancher host_ip:port as pool members

* This f5 pool created will have a name of the pattern of"service.Name"_"environment_uuid"_"rancher.internal"  - The suffix "rancher.internal" is configurable while launching the catalog template.

* This pool will be assigned to the f5 virtual server provided to Rancher via the above label

* After the f5 configuration is complete, the service on Rancher can be reached using the f5 vip:port

* Rancher’s f5 service will keep on synching new services to f5 and remove/scale up-scale down as changes are made on Rancher.
