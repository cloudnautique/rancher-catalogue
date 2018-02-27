version: '2'
services:
  network-diagnostics:
    image: rancher/network-diagnostics:v0.1.1
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
  network-diagnostics-agent:
    image: rancher/network-diagnostics-agent:v0.1.0
    labels:
      io.rancher.scheduler.global: 'true'
    pid: host
    privileged: true
    volumes:
      - /var/run/docker:/var/run/docker
      - /var/run/docker.sock:/var/run/docker.sock
    command:
      - network-diagnostics-agent
      - --backend=ipsec
      {{- if ne .Values.INFO_COLLECTION_INTERVAL "600000" }}
      - --info-collection-interval=${INFO_COLLECTION_INTERVAL}
      {{- end }}
      {{- if ne .Values.INFO_HISTORY_LENGTH "1000" }}
      - --info-history-length=${INFO_HISTORY_LENGTH}
      {{- end }}
      {{- if eq .Values.RANCHER_DEBUG "true" }}
      - --debug
      {{- end }}
    logging:
      driver: json-file
      options:
        max-size: 25m
        max-file: '2'
