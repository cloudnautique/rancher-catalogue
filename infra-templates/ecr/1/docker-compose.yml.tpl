ecr-updater:
  environment:
    AWS_ACCESS_KEY_ID: ${AWS_ACCESS_KEY_ID}
    AWS_SECRET_ACCESS_KEY: ${AWS_SECRET_ACCESS_KEY}
    AWS_REGION: ${AWS_REGION}
    AUTO_CREATE: ${AUTO_CREATE}
    LOG_LEVEL: ${LOG_LEVEL}
    {{- if eq .Values.registry_in_which_environment "other" }}
    CATTLE_URL: ${environment_api_endpoint}
    CATTLE_ACCESS_KEY: ${environment_api_access_key}
    CATTLE_SECRET_KEY: ${environment_api_secret_key}
    {{- end }}
  labels:
    io.rancher.container.pull_image: always
    {{- if eq .Values.registry_in_which_environment "current" }}
    io.rancher.container.create_agent: 'true'
    io.rancher.container.agent.role: environment
    {{- end }}
  tty: true
  image: rancher/rancher-ecr-credentials:v2.0.1
  stdin_open: true
