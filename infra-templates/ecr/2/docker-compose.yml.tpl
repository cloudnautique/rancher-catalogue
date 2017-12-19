ecr-updater:
  environment:
    AWS_ACCESS_KEY_ID: ${aws_access_key_id}
    AWS_SECRET_ACCESS_KEY: ${aws_secret_access_key}
    AWS_REGION: ${aws_region}
    AUTO_CREATE: ${auto_create}
    LOG_LEVEL: ${log_level}
    {{- if eq .Values.is_other_environment "other" }}
    CATTLE_URL: ${cattle_url}
    CATTLE_ACCESS_KEY: ${cattle_access_key}
    CATTLE_ACCESS_SECRET: ${cattle_access_secret}
    {{- end }}
  labels:
    io.rancher.container.pull_image: always
    {{- if eq .Values.is_other_environment "current" }}
    io.rancher.container.create_agent: 'true'
    io.rancher.container.agent.role: environment
    {{- end }}
  tty: true
  image: rancher/rancher-ecr-credentials:v2.0.1
  stdin_open: true
