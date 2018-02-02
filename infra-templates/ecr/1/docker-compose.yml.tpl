ecr-updater:
  environment:
    AWS_ACCESS_KEY_ID: ${aws_access_key_id}
    AWS_SECRET_ACCESS_KEY: ${aws_secret_access_key}
    AWS_REGION: ${aws_region}
    AUTO_CREATE: ${auto_create}
    LOG_LEVEL: ${log_level}
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
