rancher-nfs
===========

Rancher NFS volumes are created using 

## Default Configuration

The configuration questions below will apply to all volumes by default.

Each volume manifests as a uniquely-named subfolder within the NFS server's export directory. Example:

```
version: '2'
services:
  foo:
    image: alpine
    stdin_open: true
    volumes:
    - bar:/data
volumes:
  bar:
    driver: rancher-nfs
```

## Custom Configuration

By providing custom `driver_opts`, a volume may be configured to consume any NFS host/exportBase pair. Just like with the default configuration, a uniquely-named subfolder is created on the NFS server. Example:

```
version: '2'
services:
  foo:
    image: alpine
    stdin_open: true
    volumes:
    - bar:/data
volumes:
  bar:
    driver: rancher-nfs
    driver_opts:
      host: 172.22.101.100
      exportBase: /
```

For backwards compatibility, a volume may be configured to consume and NFS host/export pair. When configured in this manner, no subfolder is created; the root export directory is mounted. Example:

```
version: '2'
services:
  foo:
    image: alpine
    stdin_open: true
    volumes:
    - bar:/data
volumes:
  bar:
    driver: rancher-nfs
    driver_opts:
      host: 172.22.101.100
      export: /
```
