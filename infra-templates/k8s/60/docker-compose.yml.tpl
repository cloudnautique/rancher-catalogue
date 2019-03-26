
{{- $k8sImage:="rancher/k8s:v1.11.8-rancher1-1" }}
{{- $etcdImage:="rancher/etcd:v2.3.7-17" }}
{{- $kubectldImage:="rancher/kubectld:v0.8.8" }}
{{- $etcHostUpdaterImage:="rancher/etc-host-updater:v0.0.3" }}
{{- $k8sAgentImage:="rancher/kubernetes-agent:v0.6.9" }}
{{- $k8sAuthImage:="rancher/kubernetes-auth:v0.0.8" }}
{{- $ingressControllerImage:="rancher/lb-service-rancher:v0.9.9" }}

kubelet:
    labels:
        io.rancher.container.dns: "true"
        io.rancher.container.dns.priority: "None"
        io.rancher.container.create_agent: "true"
        io.rancher.container.agent.role: environmentAdmin
        io.rancher.scheduler.global: "true"
        {{- if eq .Values.CONSTRAINT_TYPE "required" }}
        io.rancher.scheduler.affinity:host_label: compute=true
        {{- end }}
    command:
        - kubelet
        - --kubeconfig=/etc/kubernetes/ssl/kubeconfig
        - --register-node=true
        - --cloud-provider=${CLOUD_PROVIDER}
        {{- if (or (eq .Values.CLOUD_PROVIDER "azure") (and (eq .Values.CLOUD_PROVIDER "aws") (ne .Values.CLOUD_PROVIDER_CONFIG ""))) }}
        - --cloud-config=/etc/kubernetes/cloud-provider-config
        {{- end }}
        - --allow-privileged=true
        - --healthz-bind-address=0.0.0.0
        - --cluster-dns=${DNS_CLUSTER_IP}
        - --fail-swap-on=${FAIL_ON_SWAP}
        - --cluster-domain=cluster.local
        - --network-plugin=cni
        - --cni-conf-dir=/etc/cni/managed.d
        - --anonymous-auth=false
        - --volume-plugin-dir=/var/lib/kubelet/volumeplugins
        - --client-ca-file=/etc/kubernetes/ssl/ca.pem
        - --cni-bin-dir=/opt/cni/bin,/opt/loopback/bin
        {{- if and (ne .Values.REGISTRY "") (ne .Values.POD_INFRA_CONTAINER_IMAGE "") }}
        - --pod-infra-container-image=${REGISTRY}/${POD_INFRA_CONTAINER_IMAGE}
        {{- else if (ne .Values.POD_INFRA_CONTAINER_IMAGE "") }}
        - --pod-infra-container-image=${POD_INFRA_CONTAINER_IMAGE}
        {{- end }}
        - --tls-cipher-suites=${KUBERNETES_CIPHER_SUITES}
        {{- range $i, $elem := splitPreserveQuotes .Values.ADDITIONAL_KUBELET_FLAGS }}
        - {{ $elem }}
        {{- end }}
    environment:
        CLOUD_PROVIDER: ${CLOUD_PROVIDER}
        CLOUD_PROVIDER_CONFIG: |
          ${CLOUD_PROVIDER_CONFIG}
    {{- if ne .Values.HTTP_PROXY "" }}
        HTTP_PROXY: ${HTTP_PROXY}
        HTTPS_PROXY: ${HTTP_PROXY}
        NO_PROXY: ${NO_PROXY}
    {{- end }}
    {{- if eq .Values.CLOUD_PROVIDER "azure" }}
        AZURE_TENANT_ID: ${AZURE_TENANT_ID}
        AZURE_CLIENT_ID: ${AZURE_CLIENT_ID}
        AZURE_CLIENT_SECRET: ${AZURE_CLIENT_SECRET}
        AZURE_SEC_GROUP: ${AZURE_SEC_GROUP}
        AZURE_CLOUD: ${AZURE_CLOUD}
    {{- end }}
    image: {{$k8sImage}}
    volumes:
        - /run:/run:rprivate
        - /var/run:/var/run:rprivate
        - /sys:/sys:ro,rprivate
        - /var/lib/docker:/var/lib/docker:rprivate
        - /var/lib/kubelet:/var/lib/kubelet:shared
        - /var/log/containers:/var/log/containers:rprivate
        - /var/log/pods:/var/log/pods:rprivate
        - rancher-cni-driver:/etc/cni:ro
        - rancher-cni-driver:/opt/cni:ro
        - /dev:/host/dev:rprivate
    net: host
    pid: host
    ipc: host
    privileged: true
    links:
        - kubernetes

{{- if eq .Values.CONSTRAINT_TYPE "required" }}
kubelet-unschedulable:
    labels:
        io.rancher.container.dns: "true"
        io.rancher.container.create_agent: "true"
        io.rancher.container.agent.role: environmentAdmin
        io.rancher.scheduler.global: "true"
        io.rancher.scheduler.affinity:host_label_ne: compute=true
    command:
        - kubelet
        - --kubeconfig=/etc/kubernetes/ssl/kubeconfig
        - --register-node=true
        - --cloud-provider=${CLOUD_PROVIDER}
        {{- if (or (eq .Values.CLOUD_PROVIDER "azure") (and (eq .Values.CLOUD_PROVIDER "aws") (ne .Values.CLOUD_PROVIDER_CONFIG ""))) }}
        - --cloud-config=/etc/kubernetes/cloud-provider-config
        {{- end }}
        - --allow-privileged=true
        - --anonymous-auth=false
        - --client-ca-file=/etc/kubernetes/ssl/ca.pem
        - --healthz-bind-address=0.0.0.0
        - --fail-swap-on=${FAIL_ON_SWAP}
        - --cluster-dns=${DNS_CLUSTER_IP}
        - --cluster-domain=cluster.local
        - --network-plugin=cni
        - --cni-conf-dir=/etc/cni/managed.d
        - --cni-bin-dir=/opt/cni/bin,/opt/loopback/bin
        {{- if and (ne .Values.REGISTRY "") (ne .Values.POD_INFRA_CONTAINER_IMAGE "") }}
        - --pod-infra-container-image=${REGISTRY}/${POD_INFRA_CONTAINER_IMAGE}
        {{- else if (ne .Values.POD_INFRA_CONTAINER_IMAGE "") }}
        - --pod-infra-container-image=${POD_INFRA_CONTAINER_IMAGE}
        {{- end }}
        - --register-schedulable=false
        - --tls-cipher-suites=${KUBERNETES_CIPHER_SUITES}
        {{- range $i, $elem := splitPreserveQuotes .Values.ADDITIONAL_KUBELET_FLAGS }}
        - {{ $elem }}
        {{- end }}
    environment:
        CLOUD_PROVIDER: ${CLOUD_PROVIDER}
        CLOUD_PROVIDER_CONFIG: |
          ${CLOUD_PROVIDER_CONFIG}
    {{- if ne .Values.HTTP_PROXY "" }}
        HTTP_PROXY: ${HTTP_PROXY}
        HTTPS_PROXY: ${HTTP_PROXY}
        NO_PROXY: ${NO_PROXY}
    {{- end }}
    {{- if eq .Values.CLOUD_PROVIDER "azure" }}
        AZURE_TENANT_ID: ${AZURE_TENANT_ID}
        AZURE_CLIENT_ID: ${AZURE_CLIENT_ID}
        AZURE_CLIENT_SECRET: ${AZURE_CLIENT_SECRET}
        AZURE_SEC_GROUP: ${AZURE_SEC_GROUP}
        AZURE_CLOUD: ${AZURE_CLOUD}
    {{- end }}

    image: {{$k8sImage}}
    volumes:
        - /run:/run:rprivate
        - /var/run:/var/run:rprivate
        - /sys:/sys:ro,rprivate
        - /var/lib/docker:/var/lib/docker:rprivate
        - /var/lib/kubelet:/var/lib/kubelet:shared
        - /var/log/containers:/var/log/containers:rprivate
        - /var/log/pods:/var/log/pods:rprivate
        - rancher-cni-driver:/etc/cni:ro
        - rancher-cni-driver:/opt/cni:ro
        - /dev:/host/dev:rprivate
    net: host
    pid: host
    ipc: host
    privileged: true
    links:
        - kubernetes
{{- end }}

proxy:
    command:
        - kube-proxy
        - --kubeconfig=/etc/kubernetes/ssl/kubeconfig
        - --v=2
        - --healthz-bind-address=0.0.0.0
        {{- range $i, $elem := splitPreserveQuotes .Values.ADDITIONAL_KUBEPROXY_FLAGS }}
        - {{ $elem }}
        {{- end }}
    image: {{$k8sImage}}
    labels:
        io.rancher.container.dns: "true"
        io.rancher.scheduler.global: "true"
        io.rancher.container.create_agent: "true"
        io.rancher.container.agent.role: environmentAdmin
    privileged: true
    net: host
    links:
        - kubernetes

etcd:
    image: {{$etcdImage}}
    labels:
        {{- if eq .Values.CONSTRAINT_TYPE "required" }}
        io.rancher.scheduler.affinity:host_label: etcd=true
        {{- end }}
        io.rancher.scheduler.affinity:container_label_ne: io.rancher.stack_service.name=$${stack_name}/$${service_name}
        io.rancher.sidekicks: data
        io.rancher.container.agent.role: environmentAdmin
        io.rancher.container.create_agent: 'true'
    environment:
        RANCHER_DEBUG: 'true'
        EMBEDDED_BACKUPS: '${EMBEDDED_BACKUPS}'
        BACKUP_PERIOD: '${BACKUP_PERIOD}'
        BACKUP_RETENTION: '${BACKUP_RETENTION}'
        ETCD_HEARTBEAT_INTERVAL: '${ETCD_HEARTBEAT_INTERVAL}'
        ETCD_ELECTION_TIMEOUT: '${ETCD_ELECTION_TIMEOUT}'
        ETCD_CA_FILE: '/etc/etcd/ssl/ca.pem'
        ETCD_KEY_FILE: '/etc/etcd/ssl/key.pem'
        ETCD_CERT_FILE: '/etc/etcd/ssl/cert.pem'
        ETCDCTL_CA_FILE: '/etc/etcd/ssl/ca.pem'
        ETCDCTL_KEY_FILE: '/etc/etcd/ssl/key.pem'
        ETCDCTL_CERT_FILE: '/etc/etcd/ssl/cert.pem'
        ETCDCTL_ENDPOINT: 'https://localhost:2379'
    volumes:
    - etcd:/pdata:z
    - /var/etcd/backups:/data-backup:z

data:
    image: busybox
    entrypoint: /bin/true
    net: none
    volumes:
    - /data
    labels:
        io.rancher.container.start_once: 'true'

kubernetes:
    labels:
        {{- if eq .Values.CONSTRAINT_TYPE "required" }}
        io.rancher.scheduler.affinity:host_label: orchestration=true
        {{- end }}
        io.rancher.scheduler.affinity:container_label_soft: io.rancher.stack_service.name=$${stack_name}/rancher-kubernetes-auth
        io.rancher.container.create_agent: "true"
        io.rancher.container.agent.role: environmentAdmin
        io.rancher.sidekicks: kube-hostname-updater
        io.rancher.websocket.proxy.port: "6443"
        io.rancher.websocket.proxy.scheme: "https"
        io.rancher.k8s.service.cluster.ip.range: ${SERVICE_CLUSTER_CIDR}
    command:
        - kube-apiserver
        - --storage-backend=etcd2
        - --storage-media-type=application/json
        - --service-cluster-ip-range=${SERVICE_CLUSTER_CIDR}
        - --etcd-servers=https://etcd.kubernetes.rancher.internal:2379
        - --insecure-bind-address=0.0.0.0
        - --insecure-port=0
        - --cloud-provider=${CLOUD_PROVIDER}
        {{- if (or (eq .Values.CLOUD_PROVIDER "azure") (and (eq .Values.CLOUD_PROVIDER "aws") (ne .Values.CLOUD_PROVIDER_CONFIG ""))) }}
        - --cloud-config=/etc/kubernetes/cloud-provider-config
        {{- end }}
        - --allow-privileged=true
        - --admission-control=$ADMISSION_CONTROLLERS
        - --client-ca-file=/etc/kubernetes/ssl/ca.pem
        - --tls-cert-file=/etc/kubernetes/ssl/cert.pem
        - --tls-private-key-file=/etc/kubernetes/ssl/key.pem
        - --kubelet-client-certificate=/etc/kubernetes/ssl/cert.pem
        - --kubelet-client-key=/etc/kubernetes/ssl/key.pem
        - --runtime-config=batch/v2alpha1
        - --anonymous-auth=false
        - --authentication-token-webhook-config-file=/etc/kubernetes/authconfig
        - --runtime-config=authentication.k8s.io/v1beta1=true
        - --external-hostname=kubernetes.kubernetes.rancher.internal
        - --etcd-cafile=/etc/kubernetes/etcd/ca.pem
        - --etcd-certfile=/etc/kubernetes/etcd/cert.pem
        - --etcd-keyfile=/etc/kubernetes/etcd/key.pem
        {{- if eq .Values.AUDIT_LOGS "true" }}
        - --audit-log-path=-
        - --feature-gates=AdvancedAuditing=false
        {{- end }}
        {{- if eq .Values.RBAC "true" }}
        - --authorization-mode=RBAC
        {{- end }}
        - --tls-cipher-suites=${KUBERNETES_CIPHER_SUITES}
        {{- range $i, $elem := splitPreserveQuotes .Values.ADDITIONAL_KUBEAPI_FLAGS }}
        - {{ $elem }}
        {{- end }}
    environment:
        CLOUD_PROVIDER: ${CLOUD_PROVIDER}
        CLOUD_PROVIDER_CONFIG: |
          ${CLOUD_PROVIDER_CONFIG}
        KUBERNETES_URL: https://kubernetes.kubernetes.rancher.internal:6443
        {{- if ne .Values.HTTP_PROXY "" }}
        HTTP_PROXY: ${HTTP_PROXY}
        HTTPS_PROXY: ${HTTP_PROXY}
        NO_PROXY: ${NO_PROXY}
        {{- end }}
        {{- if eq .Values.CLOUD_PROVIDER "azure" }}
        AZURE_TENANT_ID: ${AZURE_TENANT_ID}
        AZURE_CLIENT_ID: ${AZURE_CLIENT_ID}
        AZURE_CLIENT_SECRET: ${AZURE_CLIENT_SECRET}
        AZURE_SEC_GROUP: ${AZURE_SEC_GROUP}
        AZURE_CLOUD: ${AZURE_CLOUD}
        {{- end }}
    image: {{$k8sImage}}
    links:
        - etcd

kube-hostname-updater:
    net: container:kubernetes
    command:
        - etc-host-updater
    image: {{$etcHostUpdaterImage}}
    links:
        - kubernetes

kubectld:
    labels:
        {{- if eq .Values.CONSTRAINT_TYPE "required" }}
        io.rancher.scheduler.affinity:host_label: orchestration=true
        {{- end }}
        io.rancher.container.create_agent: "true"
        io.rancher.container.agent_service.kubernetes_stack: "true"
    environment:
        SERVER: http://kubernetes.kubernetes.rancher.internal
        LISTEN: ":8091"
    image: {{$kubectldImage}}
    links:
        - kubernetes

kubectl-shell:
    labels:
        {{- if eq .Values.CONSTRAINT_TYPE "required" }}
        io.rancher.scheduler.affinity:host_label: orchestration=true
        {{- end }}
        io.rancher.container.create_agent: "true"
        io.rancher.container.agent.role: environmentAdmin
        io.rancher.k8s.kubectld: "true"
        io.rancher.k8s.token: "true"
    command:
        - kubectl-shell-entry.sh
    image: {{$kubectldImage}}
    privileged: true
    health_check:
        port: 10240
        interval: 2000
        response_timeout: 2000
        unhealthy_threshold: 3
        healthy_threshold: 2
        initializing_timeout: 60000
        reinitializing_timeout: 60000


scheduler:
    command:
        - kube-scheduler
        - --kubeconfig=/etc/kubernetes/ssl/kubeconfig
        - --address=0.0.0.0
        {{- range $i, $elem := splitPreserveQuotes .Values.ADDITIONAL_KUBESCHEDULER_FLAGS }}
        - {{ $elem }}
        {{- end }}
    image: {{$k8sImage}}
    labels:
        {{- if eq .Values.CONSTRAINT_TYPE "required" }}
        io.rancher.scheduler.affinity:host_label: orchestration=true
        {{- end }}
        io.rancher.container.create_agent: "true"
        io.rancher.container.agent.role: environmentAdmin
    links:
        - kubernetes

controller-manager:
    command:
        - kube-controller-manager
        - --kubeconfig=/etc/kubernetes/ssl/kubeconfig
        - --allow-untagged-cloud
        - --cloud-provider=${CLOUD_PROVIDER}
        {{- if (or (eq .Values.CLOUD_PROVIDER "azure") (and (eq .Values.CLOUD_PROVIDER "aws") (ne .Values.CLOUD_PROVIDER_CONFIG ""))) }}
        - --cloud-config=/etc/kubernetes/cloud-provider-config
        {{- end }}
        - --address=0.0.0.0
        - --root-ca-file=/etc/kubernetes/ssl/ca.pem
        - --service-account-private-key-file=/etc/kubernetes/ssl/key.pem
        - --horizontal-pod-autoscaler-use-rest-clients=false
        {{- range $i, $elem := splitPreserveQuotes .Values.ADDITIONAL_KUBECONTROLLERMANAGER_FLAGS }}
        - {{ $elem }}
        {{- end }}
    environment:
        CLOUD_PROVIDER: ${CLOUD_PROVIDER}
        CLOUD_PROVIDER_CONFIG: |
          ${CLOUD_PROVIDER_CONFIG}
        {{- if ne .Values.HTTP_PROXY "" }}
        HTTP_PROXY: ${HTTP_PROXY}
        HTTPS_PROXY: ${HTTP_PROXY}
        NO_PROXY: ${NO_PROXY}
        {{- end }}
        {{- if eq .Values.CLOUD_PROVIDER "azure" }}
        AZURE_TENANT_ID: ${AZURE_TENANT_ID}
        AZURE_CLIENT_ID: ${AZURE_CLIENT_ID}
        AZURE_CLIENT_SECRET: ${AZURE_CLIENT_SECRET}
        AZURE_SEC_GROUP: ${AZURE_SEC_GROUP}
        AZURE_CLOUD: ${AZURE_CLOUD}
        {{- end }}
    image: {{$k8sImage}}
    labels:
        {{- if eq .Values.CONSTRAINT_TYPE "required" }}
        io.rancher.scheduler.affinity:host_label: orchestration=true
        {{- end }}
        io.rancher.container.create_agent: "true"
        io.rancher.container.agent.role: environmentAdmin
    links:
        - kubernetes

rancher-kubernetes-agent:
    labels:
        {{- if eq .Values.CONSTRAINT_TYPE "required" }}
        io.rancher.scheduler.affinity:host_label: orchestration=true
        {{- end }}
        io.rancher.container.create_agent: "true"
        io.rancher.container.agent.role: agent,environmentAdmin
        io.rancher.container.agent_service.labels_provider: "true"
        io.rancher.k8s.agent: "true"
    environment:
        KUBERNETES_URL: https://kubernetes.kubernetes.rancher.internal:6443
    image: {{$k8sAgentImage}}
    privileged: true
    volumes:
        - /var/run/docker.sock:/var/run/docker.sock
    links:
        - kubernetes

{{- if eq .Values.ENABLE_RANCHER_INGRESS_CONTROLLER "true" }}
rancher-ingress-controller:
    image: {{$ingressControllerImage}}
    labels:
        {{- if eq .Values.CONSTRAINT_TYPE "required" }}
        io.rancher.scheduler.affinity:host_label: orchestration=true
        {{- end }}
        io.rancher.container.create_agent: "true"
        io.rancher.container.agent.role: environmentAdmin
    environment:
        KUBERNETES_URL: https://kubernetes.kubernetes.rancher.internal:6443
        RANCHER_LB_SEPARATOR: $RANCHER_LB_SEPARATOR
        RANCHER_METADATA_ADDRESS: $RANCHER_METADATA_ADDRESS
    command:
        - lb-controller
        - --controller=kubernetes
        - --provider=rancher
    links:
        - kubernetes
    health_check:
        request_line: GET /healthz HTTP/1.0
        port: 10241
        interval: 2000
        response_timeout: 2000
        unhealthy_threshold: 3
        healthy_threshold: 2
        initializing_timeout: 60000
        reinitializing_timeout: 60000
{{- end }}

rancher-kubernetes-auth:
    image: {{$k8sAuthImage}}
    labels:
        {{- if eq .Values.CONSTRAINT_TYPE "required" }}
        io.rancher.scheduler.affinity:host_label: orchestration=true
        {{- end }}
        io.rancher.scheduler.affinity:container_label: io.rancher.stack_service.name=$${stack_name}/kubernetes
        io.rancher.container.create_agent: "true"
        io.rancher.container.agent.role: environmentAdmin
    health_check:
        request_line: GET /healthcheck HTTP/1.0
        port: 10240
        interval: 2000
        response_timeout: 2000
        unhealthy_threshold: 3
        healthy_threshold: 2
        initializing_timeout: 60000
        reinitializing_timeout: 60000

{{- if eq .Values.ENABLE_ADDONS "true" }}
addon-starter:
    image: {{$k8sImage}}
    labels:
        {{- if eq .Values.CONSTRAINT_TYPE "required" }}
        io.rancher.scheduler.affinity:host_label: orchestration=true
        {{- end }}
        io.rancher.container.create_agent: 'true'
        io.rancher.container.agent.role: environmentAdmin
    environment:
        KUBERNETES_URL: https://kubernetes.kubernetes.rancher.internal:6443
        REGISTRY: ${REGISTRY}
        INFLUXDB_HOST_PATH: ${INFLUXDB_HOST_PATH}
        DNS_REPLICAS: ${DNS_REPLICAS}
        DNS_CLUSTER_IP: ${DNS_CLUSTER_IP}
        BASE_IMAGE_NAMESPACE: ${BASE_IMAGE_NAMESPACE}
        HELM_IMAGE_NAMESPACE: ${HELM_IMAGE_NAMESPACE}
        ADDONS_LOG_VERBOSITY_LEVEL: ${ADDONS_LOG_VERBOSITY_LEVEL}
        DASHBOARD_CPU_LIMIT: ${DASHBOARD_CPU_LIMIT}
        DASHBOARD_MEMORY_LIMIT: ${DASHBOARD_MEMORY_LIMIT}

    command:
        - addons-update.sh
    links:
        - kubernetes
    health_check:
        port: 10240
        interval: 2000
        response_timeout: 2000
        unhealthy_threshold: 3
        healthy_threshold: 2
        initializing_timeout: 60000
        reinitializing_timeout: 60000
{{- end }}
