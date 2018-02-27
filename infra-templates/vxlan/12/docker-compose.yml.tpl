version: '2'

{{- $netImage:="rancher/net:v0.13.1" }}

services:
  vxlan:
    cap_add:
      - NET_ADMIN
    image: {{$netImage}}
    command: start-vxlan.sh
    network_mode: host
    environment:
      RANCHER_DEBUG: '${RANCHER_DEBUG}'
    ports:
      - 0.0.0.0:4789:4789/udp
    labels:
      io.rancher.scheduler.global: 'true'
      io.rancher.cni.link_mtu_overhead: '0'
      io.rancher.internal.service.vxlan: 'true'
      io.rancher.service.selector.link: io.rancher.internal.service.vxlan=true
      io.rancher.network.macsync: 'false'
      io.rancher.network.arpsync: 'false'
      io.rancher.container.dns: 'true'
    logging:
      driver: json-file
      options:
        max-size: 25m
        max-file: '2'
  cni-driver:
    privileged: true
    image: {{$netImage}}
    command: start-cni-driver.sh
    network_mode: host
    pid: host
    environment:
      RANCHER_DEBUG: '${RANCHER_DEBUG}'
    labels:
      io.rancher.scheduler.global: 'true'
      io.rancher.network.cni.binary: 'rancher-bridge'
      io.rancher.container.dns: 'true'
    logging:
      driver: json-file
      options:
        max-size: 25m
        max-file: '2'
    volumes:
    - /var/run/docker.sock:/var/run/docker.sock
    - rancher-cni-driver:/opt/cni-driver
    network_driver:
      name: Rancher VXLAN
      default_network:
        name: vxlan
        host_ports: {{ .Values.HOST_PORTS }}
        subnets:
        - network_address: $SUBNET
        dns:
        - 169.254.169.250
        dns_search:
        - rancher.internal
      cni_config:
        '10-rancher-vxlan.conf':
          name: rancher-cni-network
          type: rancher-bridge
          bridge: $DOCKER_BRIDGE
          bridgeSubnet: $SUBNET
          logToFile: /var/log/rancher-cni.log
          isDebugLevel: ${RANCHER_DEBUG}
          isDefaultGateway: true
          hairpinMode: true
          hostNat: true
          hairpinMode: {{  .Values.RANCHER_HAIRPIN_MODE }}
          promiscMode: {{ .Values.RANCHER_PROMISCUOUS_MODE }}
          mtu: ${MTU}
          linkMTUOverhead: 50
          ipam:
            type: rancher-cni-ipam
            subnetPrefixSize: /{{ .Values.SUBNET_PREFIX }}
            logToFile: /var/log/rancher-cni.log
            isDebugLevel: ${RANCHER_DEBUG}
