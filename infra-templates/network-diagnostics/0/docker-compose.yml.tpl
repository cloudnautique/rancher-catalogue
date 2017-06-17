version: '2'
services:
  network-diagnostics:
    image: rancher/network-diagnostics:0.1.1
    labels:
      io.rancher.container.create_agent: 'true'
      io.rancher.container.agent.role: 'environmentAdmin'
    command:
      - start.sh
      {{- if eq .Values.RANCHER_DEBUG "true" }}
      - --debug
      {{- end }}
    logging:
      driver: json-file
      options:
        max-size: 25m
        max-file: '2'
