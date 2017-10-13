version: '2'

{{- $k8sImage:="rancher/k8s:v1.8.1-rancher1" }}
{{- $etcdImage:="rancher/etcd:v3.0.17-4" }}
{{- $kubectldImage:="rancher/kubectld:v0.8.5" }}
{{- $etcHostUpdaterImage:="rancher/etc-host-updater:v0.0.3" }}
{{- $k8sAgentImage:="rancher/kubernetes-agent:v0.6.6" }}
{{- $k8sAuthImage:="rancher/kubernetes-auth:v0.0.8" }}
{{- $ingressControllerImage:="rancher/lb-service-rancher:v0.7.10" }}

services:
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
    - --allow-privileged=true
    - --register-node=true
    - --cloud-provider=${CLOUD_PROVIDER}
    - --healthz-bind-address=0.0.0.0
    - --cluster-dns=${DNS_CLUSTER_IP}
    - --cluster-domain=cluster.local
    - --network-plugin=cni
    - --cni-conf-dir=/etc/cni/managed.d
    {{- if and (ne .Values.REGISTRY "") (ne .Values.POD_INFRA_CONTAINER_IMAGE "") }}
    - --pod-infra-container-image=${REGISTRY}/${POD_INFRA_CONTAINER_IMAGE}
    {{- else if (ne .Values.POD_INFRA_CONTAINER_IMAGE "") }}
    - --pod-infra-container-image=${POD_INFRA_CONTAINER_IMAGE}
    {{- end }}
    {{- range $i, $elem := splitPreserveQuotes .Values.ADDITIONAL_KUBELET_FLAGS }}
    - {{ $elem }}
    {{- end }}
    {{- if ne .Values.HTTP_PROXY "" }}
    environment:
        HTTP_PROXY: ${HTTP_PROXY}
        HTTPS_PROXY: ${HTTP_PROXY}
        NO_PROXY: ${NO_PROXY}
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
    network_mode: host
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
    - --allow-privileged=true
    - --register-node=true
    - --cloud-provider=${CLOUD_PROVIDER}
    - --healthz-bind-address=0.0.0.0
    - --cluster-dns=${DNS_CLUSTER_IP}
    - --cluster-domain=cluster.local
    - --network-plugin=cni
    - --cni-conf-dir=/etc/cni/managed.d
    {{- if and (ne .Values.REGISTRY "") (ne .Values.POD_INFRA_CONTAINER_IMAGE "") }}
    - --pod-infra-container-image=${REGISTRY}/${POD_INFRA_CONTAINER_IMAGE}
    {{- else if (ne .Values.POD_INFRA_CONTAINER_IMAGE "") }}
    - --pod-infra-container-image=${POD_INFRA_CONTAINER_IMAGE}
    {{- end }}
    - --register-schedulable=false
    {{- range $i, $elem := splitPreserveQuotes .Values.ADDITIONAL_KUBELET_FLAGS }}
    - {{ $elem }}
    {{- end }}
    {{- if ne .Values.HTTP_PROXY "" }}
    environment:
        HTTP_PROXY: ${HTTP_PROXY}
        HTTPS_PROXY: ${HTTP_PROXY}
        NO_PROXY: ${NO_PROXY}
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
    network_mode: host
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
    image: {{$k8sImage}}
    labels:
      io.rancher.container.dns: "true"
      io.rancher.scheduler.global: "true"
      io.rancher.container.create_agent: "true"
      io.rancher.container.agent.role: environmentAdmin
    privileged: true
    network_mode: host
    links:
    - kubernetes

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
    command:
    - kube-apiserver
    - --storage-backend=etcd3
    - --service-cluster-ip-range=${SERVICE_CLUSTER_CIDR}
    - --etcd-servers=http://etcd.kubernetes.rancher.internal:2379
    - --insecure-bind-address=0.0.0.0
    - --insecure-port=0
    - --cloud-provider=${CLOUD_PROVIDER}
    - --allow_privileged=true
    - --admission-control=NamespaceLifecycle,LimitRanger,ServiceAccount,PersistentVolumeLabel,DefaultStorageClass,ResourceQuota,DefaultTolerationSeconds
    - --client-ca-file=/etc/kubernetes/ssl/ca.pem
    - --tls-cert-file=/etc/kubernetes/ssl/cert.pem
    - --tls-private-key-file=/etc/kubernetes/ssl/key.pem
    - --runtime-config=batch/v2alpha1
    - --authentication-token-webhook-config-file=/etc/kubernetes/authconfig
    - --runtime-config=authentication.k8s.io/v1beta1=true
    - --external-hostname=kubernetes.kubernetes.rancher.internal
    {{- if eq .Values.AUDIT_LOGS "true" }}
    - --audit-log-path=-
    {{- end }}
    {{- if eq .Values.RBAC "true" }}
    - --authorization-mode=RBAC
    {{- end }}
    environment:
      KUBERNETES_URL: https://kubernetes.kubernetes.rancher.internal:6443
      {{- if ne .Values.HTTP_PROXY "" }}
      HTTP_PROXY: ${HTTP_PROXY}
      HTTPS_PROXY: ${HTTP_PROXY}
      NO_PROXY: ${NO_PROXY}
      {{- end }}
    image: {{$k8sImage}}
    links:
    - etcd

  kube-hostname-updater:
    network_mode: container:kubernetes
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
    - --address=0.0.0.0
    - --root-ca-file=/etc/kubernetes/ssl/ca.pem
    - --service-account-private-key-file=/etc/kubernetes/ssl/key.pem
    {{- if ne .Values.HTTP_PROXY "" }}
    environment:
        HTTP_PROXY: ${HTTP_PROXY}
        HTTPS_PROXY: ${HTTP_PROXY}
        NO_PROXY: ${NO_PROXY}
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

  etcd:
    # IMPORTANT!!!! DO NOT CHANGE VERSION ON UPGRADE
    image: rancher/etcd:holder
    command: sh -c "echo Refer to sidekick for logs; mkfifo f; exec cat f"
    labels:
      {{- if eq .Values.CONSTRAINT_TYPE "required" }}
      io.rancher.scheduler.affinity:host_label: etcd=true
      {{- end }}
      io.rancher.scheduler.affinity:container_label_ne: io.rancher.stack_service.name=$${stack_name}/$${service_name}
      io.rancher.sidekicks: member
    scale_policy:
      increment: 1
      max: 3
      min: 1

  member:
    image: {{$etcdImage}}
    environment:
      RANCHER_DEBUG: 'true'
      ETCD_HEARTBEAT_INTERVAL: '${ETCD_HEARTBEAT_INTERVAL}'
      ETCD_ELECTION_TIMEOUT: '${ETCD_ELECTION_TIMEOUT}'
    network_mode: container:etcd
    volumes:
    - etcd-data:/data:z
    {{- if ne .Values.RESTORE_BACKUP "" }}
    - /var/etcd/backups:/backup:z
    {{- end }}
    health_check:
      port: 2378
      request_line: GET /health HTTP/1.0
      interval: 5000
      response_timeout: 3000
      unhealthy_threshold: 3
      healthy_threshold: 2
      initializing_timeout: 120000
      reinitializing_timeout: 120000
      recreate_on_quorum_strategy_config:
        quorum: 2
      strategy: recreateOnQuorum

  {{- if eq .Values.ENABLE_BACKUPS "true" }}
  etcd-backup:
    image: {{$etcdImage}}
    entrypoint: /opt/rancher/etcdwrapper
    command:
    - rolling-backup
    - --creation=${BACKUP_CREATION}
    - --retention=${BACKUP_RETENTION}
    labels:
      {{- if eq .Values.CONSTRAINT_TYPE "required" }}
      io.rancher.scheduler.affinity:host_label: etcd=true
      {{- end }}
      io.rancher.scheduler.global: "true"
    environment:
      RANCHER_DEBUG: 'true'
    volumes:
    - /var/etcd/backups:/backup:z
    links:
    - etcd
  {{- end }}
