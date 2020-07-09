version: '2'

{{- $netManagerImage:="rancher/network-manager:v0.7.22" }}
{{- $metadataImage:="rancher/metadata:v0.10.4" }}
{{- $dnsImage:="rancher/dns:v0.17.4" }}

services:
  network-manager:
    image: {{$netManagerImage}}
    privileged: true
    network_mode: host
    pid: host
    command: plugin-manager --disable-cni-setup --metadata-address 169.254.169.250 --arpsync-interval ${ARP_SYNC_INTERVAL}
    environment:
      DOCKER_BRIDGE: docker0
      METADATA_IP: 169.254.169.250
    volumes:
    - /var/run/docker.sock:/var/run/docker.sock
    - /var/lib/docker:/var/lib/docker
    - /var/lib/rancher/state:/var/lib/rancher/state
    - /lib/modules:/lib/modules:ro
    - /run:/run
    - /var/run:/var/run:ro
    - rancher-cni-driver:/etc/cni
    - rancher-cni-driver:/opt/cni
    labels:
      io.rancher.scheduler.global: 'true'
    logging:
      driver: json-file
      options:
        max-size: 25m
        max-file: '2'
  metadata:
    cap_add:
    - NET_ADMIN
    image: {{$metadataImage}}
    network_mode: bridge
    command: start.sh rancher-metadata -reload-interval-limit=${RELOAD_INTERVAL_LIMIT} -subscribe
    labels:
      io.rancher.sidekicks: dns
      io.rancher.container.create_agent: 'true'
      io.rancher.scheduler.global: 'true'
      io.rancher.container.agent_service.metadata: 'true'
    logging:
      driver: json-file
      options:
        max-size: 25m
        max-file: '2'
    sysctls:
      net.ipv4.conf.all.send_redirects: '0'
      net.ipv4.conf.default.send_redirects: '0'
      net.ipv4.conf.eth0.send_redirects: '0'
    cpu_period: ${CPU_PERIOD}
    cpu_quota: ${CPU_QUOTA}
  dns:
    image: {{$dnsImage}}
    network_mode: container:metadata
    command: rancher-dns --listen 169.254.169.250:53 --metadata-server=localhost --answers=/etc/rancher-dns/answers.json --recurser-timeout ${DNS_RECURSER_TIMEOUT} --ttl ${TTL}
    labels:
      io.rancher.scheduler.global: 'true'
    logging:
      driver: json-file
      options:
        max-size: 25m
        max-file: '2'
