kubelet:
    labels:
        io.rancher.container.dns: "true"
        io.rancher.container.create_agent: "true"
        io.rancher.container.agent.role: environmentAdmin
        io.rancher.scheduler.global: "true"
        {{- if eq .Values.CONSTRAINT_TYPE "required" }}
        io.rancher.scheduler.affinity:host_label: compute=true
        {{- end }}
    command:
        - kubelet
        - --kubeconfig=/etc/kubernetes/ssl/kubeconfig
        - --api_servers=https://kubernetes.kubernetes.rancher.internal:6443
        - --allow-privileged=true
        - --register-node=true
        - --cloud-provider=${CLOUD_PROVIDER}
        - --healthz-bind-address=0.0.0.0
        - --cluster-dns=10.43.0.10
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
    image: rancher/k8s:v1.7.4-rancher2
    volumes:
        - /run:/run
        - /var/run:/var/run
        - /sys:/sys:ro
        - /var/lib/docker:/var/lib/docker
        - /var/lib/kubelet:/var/lib/kubelet:shared
        - /var/log/containers:/var/log/containers
        - /var/log/pods:/var/log/pods
        - rancher-cni-driver:/etc/cni:ro
        - rancher-cni-driver:/opt/cni:ro
        - /dev:/host/dev
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
        - --api_servers=https://kubernetes.kubernetes.rancher.internal:6443
        - --allow-privileged=true
        - --register-node=true
        - --cloud-provider=${CLOUD_PROVIDER}
        - --healthz-bind-address=0.0.0.0
        - --cluster-dns=10.43.0.10
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
    image: rancher/k8s:v1.7.4-rancher2
    volumes:
        - /run:/run
        - /var/run:/var/run
        - /sys:/sys:ro
        - /var/lib/docker:/var/lib/docker
        - /var/lib/kubelet:/var/lib/kubelet:shared
        - /var/log/containers:/var/log/containers
        - /var/log/pods:/var/log/pods
        - rancher-cni-driver:/etc/cni:ro
        - rancher-cni-driver:/opt/cni:ro
        - /dev:/host/dev
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
    image: rancher/k8s:v1.7.4-rancher2
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
    image: rancher/etcd:v2.3.7-13
    labels:
        {{- if eq .Values.CONSTRAINT_TYPE "required" }}
        io.rancher.scheduler.affinity:host_label: etcd=true
        {{- end }}
        io.rancher.scheduler.affinity:container_label_ne: io.rancher.stack_service.name=$${stack_name}/$${service_name}
        io.rancher.sidekicks: data
    environment:
        RANCHER_DEBUG: 'true'
        EMBEDDED_BACKUPS: '${EMBEDDED_BACKUPS}'
        BACKUP_PERIOD: '${BACKUP_PERIOD}'
        BACKUP_RETENTION: '${BACKUP_RETENTION}'
        ETCD_HEARTBEAT_INTERVAL: '${ETCD_HEARTBEAT_INTERVAL}'
        ETCD_ELECTION_TIMEOUT: '${ETCD_ELECTION_TIMEOUT}'
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
    command:
        - kube-apiserver
        - --storage-backend=etcd2
        - --service-cluster-ip-range=10.43.0.0/16
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
        {{- if eq .Values.AUDIT_LOGS "true" }}
        - --audit-log-path=-
        {{- end }}
        {{- if eq .Values.RBAC "true" }}
        - --authorization-mode=RBAC
        {{- end }}
    environment:
        KUBERNETES_URL: https://kubernetes.kubernetes.rancher.internal:6443
    image: rancher/k8s:v1.7.4-rancher2
    links:
        - etcd

kube-hostname-updater:
    net: container:kubernetes
    command:
        - etc-host-updater
    image: rancher/etc-host-updater:v0.0.3
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
    image: rancher/kubectld:v0.8.3
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
    image: rancher/kubectld:v0.8.3
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
    image: rancher/k8s:v1.7.4-rancher2
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
        - --cloud-provider=${CLOUD_PROVIDER}
        - --address=0.0.0.0
        - --root-ca-file=/etc/kubernetes/ssl/ca.pem
        - --service-account-private-key-file=/etc/kubernetes/ssl/key.pem
    image: rancher/k8s:v1.7.4-rancher2
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
    image: rancher/kubernetes-agent:v0.6.5
    privileged: true
    volumes:
        - /var/run/docker.sock:/var/run/docker.sock
    links:
        - kubernetes

{{- if eq .Values.ENABLE_RANCHER_INGRESS_CONTROLLER "true" }}
rancher-ingress-controller:
    image: rancher/lb-service-rancher:v0.7.10
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
    image: rancher/kubernetes-auth:v0.0.8
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
    image: rancher/k8s:v1.7.4-rancher2
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
