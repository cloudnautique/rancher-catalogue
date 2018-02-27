version: '2'
services:
  vxlan:
    # IMPORTANT!!!! DO NOT CHANGE VERSION ON UPGRADE
    image: rancher/net:holder
    command: sh -c "echo Refer to router sidekick for logs; mkfifo f; exec cat f"
    network_mode: vxlan
    ports:
      - 4789:4789/udp
    labels:
      io.rancher.sidekicks: router
      io.rancher.scheduler.global: 'true'
      io.rancher.cni.link_mtu_overhead: '0'
      io.rancher.internal.service.vxlan: 'true'
      io.rancher.service.selector.link: io.rancher.internal.service.vxlan=true
      io.rancher.network.macsync: 'true'
      io.rancher.network.arpsync: 'true'
    logging:
      driver: json-file
      options:
        max-size: 25m
        max-file: '2'
  router:
    cap_add:
      - NET_ADMIN
    image: rancher/net:v0.11.9
    network_mode: container:vxlan
    environment:
      RANCHER_DEBUG: '${RANCHER_DEBUG}'
      VXLAN_VTEP_MTU: '${MTU}'
    command: start-vxlan.sh
    logging:
      driver: json-file
      options:
        max-size: 25m
        max-file: '2'
    sysctls:
      net.ipv4.conf.all.send_redirects: '0'
      net.ipv4.conf.default.send_redirects: '0'
      net.ipv4.conf.eth0.send_redirects: '0'
  cni-driver:
    privileged: true
    image: rancher/net:v0.13.1
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
