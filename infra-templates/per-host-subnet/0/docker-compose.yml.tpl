version: '2'

{{- $netImage:="rancher/net:v0.13.3" }}

services:
  per-host-subnet:
    privileged: true
    pid: host
    network_mode: host
    image: {{$netImage}}
    command: per-host-subnet
    environment:
      RANCHER_DEBUG: '${RANCHER_DEBUG}'
      RANCHER_METADATA_ADDRESS: '${RANCHER_METADATA_ADDRESS}'
      RANCHER_ENABLE_ROUTE_UPDATE: '${RANCHER_ENABLE_ROUTE_UPDATE}'
      RANCHER_ROUTE_UPDATE_PROVIDER: '${RANCHER_ROUTE_UPDATE_PROVIDER}'
    logging:
      driver: json-file
      options:
        max-size: 25m
        max-file: '2'
    labels:
      io.rancher.scheduler.global: 'true'
  cni-driver:
    privileged: true
    image: {{$netImage}}
    command: start-cni-driver.sh
    network_mode: host
    pid: host
    environment:
      RANCHER_DEBUG: '${RANCHER_DEBUG}'
    volumes:
    - /var/lib/rancher/per_host_subnet:/var/lib/cni/networks
    - /var/run/docker.sock:/var/run/docker.sock
    - rancher-cni-driver:/opt/cni-driver
    labels:
      io.rancher.network.cni.binary: 'rancher-bridge'
      io.rancher.container.dns: 'true'
      io.rancher.scheduler.global: 'true'
    logging:
      driver: json-file
      options:
        max-size: 25m
        max-file: '2'
    network_driver:
      name: Rancher Per Host Subnet
      default_network:
        name: per-host-subnet
        host_ports: {{ .Values.HOST_PORTS }}
        dns:
        - 169.254.169.250
        dns_search:
        - rancher.internal
      cni_config:
        '10-per-host-subnet.conf':
          name: per-host-subnet-network
          type: rancher-bridge
          bridge: ${BRIDGE}
          bridgeSubnet: "__host_label__: io.rancher.network.per_host_subnet.subnet"
          isDebugLevel: ${RANCHER_DEBUG}
          logToFile: /var/log/rancher-cni.log
          isDefaultGateway: true
          hostNat: {{ .Values.HOST_NAT  }}
          hairpinMode: {{  .Values.RANCHER_HAIRPIN_MODE  }}
          promiscMode: {{ .Values.RANCHER_PROMISCUOUS_MODE  }}
          mtu: ${MTU}
          ipam:
            type: rancher-host-local-ipam
            subnet: "__host_label__: io.rancher.network.per_host_subnet.subnet"
            rangeStart: "__host_label__: io.rancher.network.per_host_subnet.range_start"
            rangeEnd: "__host_label__: io.rancher.network.per_host_subnet.range_end"
            isDebugLevel: ${RANCHER_DEBUG}
            logToFile: /var/log/rancher-cni.log
