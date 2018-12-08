version: '2'
services:
  portworx:
    image: portworx/oci-monitor:1.7.2
    container_name: px-oci-mon
    privileged: true
    labels:
      io.rancher.container.dns: 'true'
      {{- if eq .Values.INSTALL_SCALE "global" }}
      io.rancher.scheduler.global: 'true'
      {{- end }}
      io.rancher.container.pull_image: always
      io.rancher.container.hostname_override: container_name
      io.rancher.scheduler.affinity:container_label_ne: io.rancher.stack_service.name=$${stack_name}/$${service_name}
      io.rancher.scheduler.affinity:host_label_ne: px/enabled=false
    environment:
      CLUSTER_ID: ${CLUSTER_ID}
      KVDB: ${KVDB}
      USE_DISKS: ${USE_DISKS}
      EXTRA_OPTS: ${EXTRA_OPTS}
      ENABLE_ATTR_CACHE: true
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:rprivate
      - /etc/pwx:/etc/pwx:rprivate
      - /opt/pwx:/opt/pwx:rprivate
      - /etc/systemd/system:/etc/systemd/system:rprivate
      - /proc/1/ns:/host_proc/1/ns:rprivate
      - /var/run/dbus:/var/run/dbus:rprivate
    command: -c ${CLUSTER_ID} -k ${KVDB} ${USE_DISKS} -x rancher --endpoint 0.0.0.0:9015 ${EXTRA_OPTS}
