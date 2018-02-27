## Rancher NFS

### Changelog - 0.4.0

#### Rancher NFS [rancher/storage-nfs:v0.8.5]
 * Added new driver option `onRemove=retain|purge` to conditionally preserve data
 * Added support for NFS v3
 * Improved the framework and driver logging

### Default Configuration

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

### Custom Configuration

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

### Preserve Data

In order to preserve a volume's data on the NFS server after the volume is deleted from Rancher, specify `onRemove: retain` in `driver_opts`.

```
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
      onRemove: retain
```

### Backwards Compatibility

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

### Preserving data on volume removal
The default value for the `onRemove` driver option is `purge`. This means that the underlying data will be removed if the volume is removed from Rancher. If you want to retain the underlying data, you can specify the `retain` value. You can also override this behavior on a per-volume basis. If the nfs-driver option `onRemove` is set to `retain`, but you want to purge the data of a particular volume when it's removed from Rancher, you can configure `onRemove: purge` in the `driver_opts` of the volume specification inside `docker-compose.yml` like in the example below.

```yaml
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
      onRemove: purge
```

If the nfs-driver option `onRemove` is set to `purge`, you can configure `onRemove: retain` in the `driver_opts` of the volume specification to preserve the data after the volume is removed in Rancher.

```yaml
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
      onRemove: retain
```

> **Note:** Creating an external volume with the same name as a previously removed volume with retained data will make the retained data accessible to the container using this volume.
