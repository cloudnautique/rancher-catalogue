version: '2'
services:
  etcd-operator:
    image: llparse/etcd-operator:dev
    command:
    - --debug=${DEBUG}
    - rancher
    - operator
    - --analytics=${ANALYTICS}
    - --gc-interval=${GC_INTERVAL}
    - --chaos-level=${CHAOS_LEVEL}
    {{- if ne .Values.CATTLE_URL "" }}
    environment:
      CATTLE_URL: ${CATTLE_URL}
      CATTLE_ACCESS_KEY: ${CATTLE_ACCESS_KEY}
      CATTLE_SECRET_KEY: ${CATTLE_SECRET_KEY}
    {{- end }}
    labels:
    {{- if eq .Values.CATTLE_URL "" }}
      io.rancher.container.agent.role: environmentAdmin
      io.rancher.container.create_agent: "true"
    {{- end }}
      io.rancher.container.dns: 'true'
      io.rancher.container.pull_image: always
    network_mode: host
    stdin_open: true
    tty: true
