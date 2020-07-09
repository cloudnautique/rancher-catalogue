version: '2'

{{- $netImage:="rancher/net:v0.13.17" }}

services:
  ipsec:
    # IMPORTANT!!!! DO NOT CHANGE VERSION ON UPGRADE
    image: rancher/net:holder
    command: sh -c "echo Refer to router sidekick for logs; mkfifo f; exec cat f"
    network_mode: ipsec
    ports:
      - 0.0.0.0:500:500/udp
      - 0.0.0.0:4500:4500/udp
    labels:
      io.rancher.sidekicks: router,connectivity-check
      io.rancher.scheduler.global: 'true'
      io.rancher.cni.link_mtu_overhead: '0'
      io.rancher.network.macsync: 'true'
      io.rancher.network.arpsync: 'true'
  router:
    cap_add:
      - NET_ADMIN
    image: {{$netImage}}
    command: start-ipsec.sh
    network_mode: container:ipsec
    environment:
      RANCHER_DEBUG: '${RANCHER_DEBUG}'
      IPSEC_REPLAY_WINDOW_SIZE: '${IPSEC_REPLAY_WINDOW_SIZE}'
      IPSEC_IKE_SA_REKEY_INTERVAL: '${IPSEC_IKE_SA_REKEY_INTERVAL}'
      IPSEC_CHILD_SA_REKEY_INTERVAL: '${IPSEC_CHILD_SA_REKEY_INTERVAL}'
      RANCHER_IPSEC_PSK: '${RANCHER_IPSEC_PSK}'
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
  connectivity-check:
    image: {{$netImage}}
    command:
      - connectivity-check
      {{- if ne .Values.CONNECTIVITY_CHECK_INTERVAL "5000" }}
      - --connectivity-check-interval
      - ${CONNECTIVITY_CHECK_INTERVAL}
      {{- end }}
      {{- if ne .Values.PEER_CONNECTION_TIMEOUT "1000" }}
      - --peer-connection-timeout
      - ${PEER_CONNECTION_TIMEOUT}
      {{- end }}
    environment:
      RANCHER_DEBUG: '${RANCHER_DEBUG}'
    network_mode: container:ipsec
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
      name: Rancher IPsec
      default_network:
        name: ipsec
        host_ports: {{ .Values.HOST_PORTS }}
        subnets:
        - network_address: $SUBNET
          start_address: $SUBNET_START_ADDRESS
          end_address: $SUBNET_END_ADDRESS
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
            subnetPrefixSize: /{{ .Values.SUBNET_PREFIX }}
            logToFile: /var/log/rancher-cni.log
            isDebugLevel: ${RANCHER_DEBUG}
