version: '2'

{{- $netImage:="rancher/net:v0.13.4" }}

services:
  cni-driver:
    privileged: true
    image: {{$netImage}}
    {{- if eq .Values.AUTO_SETUP_FLAT_BRIDGE "true" }}
    environment:
      RANCHER_DEBUG: ${RANCHER_DEBUG}
      FLAT_IF: ${FLAT_IF}
      FLAT_BRIDGE: ${FLAT_BRIDGE}
      MTU: ${MTU}
      RANCHER_METADATA_ADDRESS: ${RANCHER_METADATA_ADDRESS}
    command: sh -c "start-flat.sh && start-cni-driver.sh"
    {{- else }}
    environment:
      RANCHER_DEBUG: ${RANCHER_DEBUG}
      RANCHER_METADATA_ADDRESS: ${RANCHER_METADATA_ADDRESS}
    command: start-cni-driver.sh
    {{- end }}
    network_mode: host
    pid: host
    labels:
      io.rancher.network.cni.binary: 'rancher-bridge'
      io.rancher.container.dns: 'true'
      io.rancher.scheduler.global: 'true'
    volumes:
    - /var/run/docker.sock:/var/run/docker.sock
    - rancher-cni-driver:/opt/cni-driver
    logging:
      driver: json-file
      options:
        max-size: 25m
        max-file: '2'
    network_driver:
      name: Rancher Flat Networking
      default_network:
        name: l2-flat
        host_ports: true
        subnets:
        - network_address: ${SUBNET}
          start_address: ${START_ADDRESS}
          end_address: ${END_ADDRESS}
        dns:
        - 169.254.169.250
        dns_search:
        - rancher.internal
      cni_config:
        '10-rancher-flat.conf':
          name: rancher-flat-network
          type: rancher-bridge
          bridge: ${FLAT_BRIDGE}
          bridgeSubnet: ${SUBNET}
          logToFile: /var/log/rancher-cni.log
          isDebugLevel: ${RANCHER_DEBUG}
          hostNat: false
          mtu: ${MTU}
          skipBridgeConfigureIP: true
          skipFastPath: true
          ipam:
            type: rancher-flat-ipam
            logToFile: /var/log/rancher-cni.log
            isDebugLevel: ${RANCHER_DEBUG}
            routes:
            - dst: 0.0.0.0/0
              gw: ${GATEWAY}
