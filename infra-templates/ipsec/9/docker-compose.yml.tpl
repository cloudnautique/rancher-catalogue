version: '2'
services:
  ipsec:
    # IMPORTANT!!!! DO NOT CHANGE VERSION ON UPGRADE
    image: rancher/net:holder
    command: sh -c "echo Refer to router sidekick for logs; mkfifo f; exec cat f"
    network_mode: ipsec
    ports:
      - 500:500/udp
      - 4500:4500/udp
    labels:
      io.rancher.sidekicks: router,cni-driver
      io.rancher.scheduler.global: 'true'
      io.rancher.cni.link_mtu_overhead: '0'
      io.rancher.network.macsync: 'true'
      io.rancher.network.arpsync: 'true'
    network_driver:
      name: Rancher IPsec
      default_network:
        name: ipsec
        host_ports: {{ .Values.HOST_PORTS }}
        subnets:
        - network_address: $SUBNET
        dns:
        - 169.254.169.250
        dns_search:
        - rancher.internal
      cni_config:
        '10-rancher.conf':
          name: rancher-cni-network
          type: rancher-bridge
          bridge: $DOCKER_BRIDGE
          bridgeSubnet: $SUBNET
          logToFile: /var/log/rancher-cni.log
          isDebugLevel: ${RANCHER_DEBUG}
          isDefaultGateway: true
          hostNat: true
          hairpinMode: {{  .Values.RANCHER_HAIRPIN_MODE }}
          promiscMode: {{ .Values.RANCHER_PROMISCUOUS_MODE }}
          mtu: ${MTU}
          linkMTUOverhead: 98
          ipam:
            type: rancher-cni-ipam
            logToFile: /var/log/rancher-cni.log
            isDebugLevel: ${RANCHER_DEBUG}
            routes:
            - dst: 169.254.169.250/32
  router:
    cap_add:
      - NET_ADMIN
    image: rancher/net:v0.11.3
    network_mode: container:ipsec
    environment:
      RANCHER_DEBUG: '${RANCHER_DEBUG}'
    labels:
      io.rancher.container.create_agent: 'true'
      io.rancher.container.agent_service.ipsec: 'true'
    logging:
      driver: json-file
      options:
        max-size: 25m
        max-file: '2'
    sysctls:
      net.ipv4.conf.all.send_redirects: '0'
      net.ipv4.conf.default.send_redirects: '0'
      net.ipv4.conf.eth0.send_redirects: '0'
      net.ipv4.xfrm4_gc_thresh: '2147483647'
  cni-driver:
    privileged: true
    image: rancher/net:v0.11.3
    command: sh -c "touch /var/log/rancher-cni.log && exec tail ---disable-inotify -F /var/log/rancher-cni.log"
    network_mode: host
    pid: host
    labels:
      io.rancher.network.cni.binary: 'rancher-bridge'
      io.rancher.container.dns: 'true'
    logging:
      driver: json-file
      options:
        max-size: 25m
        max-file: '2'
