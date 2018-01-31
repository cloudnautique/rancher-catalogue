version: '2'

{{- $npmImage:="rancher/network-policy-manager:v0.2.7" }}

services:
  network-policy-manager:
    privileged: true
    network_mode: host
    pid: host
    image: {{$npmImage}}
    labels:
      io.rancher.scheduler.global: 'true'
    logging:
      driver: json-file
      options:
        max-size: 25m
        max-file: '2'
