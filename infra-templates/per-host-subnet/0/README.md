## Per-Host-Subnet Networking

Rancher networking plugin using per-host-subnet.

### Requirements
This network plugin requires a **unique**, **routable**, **non-overlapping** subnet to be assigned for each host in the Rancher environment. The routes to these subnets can be programmed either by this plugin by enabling the configuration option or by the network administrator either on the host or the upstream switch/router. The subnet per host has to be configured when the host is being added and **CANNOT** be changed later by modifying the label on the host.

**Note:** Some of the cloud provides may or may not allow per host subnet traffic across the hosts and this plugin expects the traffic to go through by enabling the cloud provider specific setting.

  - For example on AWS, the Src/Dst check has to disabled for all the hosts in the environment using this network plugin.

### Usage

#### Adding a host to Rancher environment
1. In `Infrastructure->Hosts->Add Host`, select `Custom`, take a note of the related `docker run` command. It will look like:
    ```
    sudo docker run --rm --privileged -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/rancher:/var/lib/rancher rancher/agent:v1.2.5 http://172.31.5.93:8080/v1/scripts/04033066C0164CF25094:1483142400000:KQrf2wQfJtdKxLHYuprV6LfWuQ
    ```

2. For each host to be added in the environment, the unique subnet to be used for this host has to be specified using the label: `io.rancher.network.per_host_subnet.subnet`.

   For example, to use the subnet `192.168.100.0/24` while adding the host, the additional launch parameter will be: `-e CATTLE_HOST_LABELS='io.rancher.network.per_host_subnet.subnet=192.168.100.0/24'`

   The final command will look like:
    ```
    sudo docker run -e CATTLE_HOST_LABELS='io.rancher.network.per_host_subnet.subnet=192.168.100.0/24'  --rm --privileged -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/rancher:/var/lib/rancher rancher/agent:v1.2.5 http://172.31.5.93:8080/v1/scripts/04033066C0164CF25094:1483142400000:KQrf2wQfJtdKxLHYuprV6LfWuQ
    ```

Note: You could use the functionality in the UI to add the label, specify the subnet and the "Add Host" command is automatically generated.


#### Configuration labels:

*Required:*

- **io.rancher.network.per\_host\_subnet.subnet**

  This label is used to specify the unique subnet to use for the container IP addresses running on the host.

  *Note:* The first usable IP address in the subnet is always assigned to the bridge.

  *Example:*
  `io.rancher.network.per_host_subnet.subnet: 192.168.100.0/24`

*Optional:*

- **io.rancher.network.per\_host\_subnet.range_start**

  This label is used to specify the starting IP address in the subnet to use for the containers. If this value is not specified, the plugin uses the second usable IP address in the subnet as the starting IP address.

  *Example:* `io.rancher.network.per_host_subnet.range_start: 192.168.100.101`

- **io.rancher.network.per\_host\_subnet.range_end**

  This label is used to specify the ending IP address in the subnet to use for the containers. If this is not specified, the plugin uses the last usable IP address in the subnet as the ending IP address.

  *Example:* `io.rancher.network.per_host_subnet.range_end: 192.168.100.200`

- **io.rancher.network.per\_host\_subnet.override\_agent\_ip**

  This label on the host is used to override the routing IP.

  *Example:* `io.rancher.network.per_host_subnet.override_agent_ip: 172.16.3.20`

### Configuration options
* `RANCHER_DEBUG`

#### cni-driver

* `BRIDGE`
* `MTU`
* `RANCHER_HAIRPIN_MODE`
* `RANCHER_PROMISCUOUS_MODE`
* `HOST_PORTS`
