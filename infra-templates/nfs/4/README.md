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
    volumes:
    - bar:/data
volumes:
  bar:
    driver: rancher-nfs
    driver_opts:
      host: 172.22.101.100
      exportBase: /
```

## Preserve Data

In order to preserve a volume's data on the NFS server after the volume is deleted from Rancher, specify `onRemove: retain` in `driver_opts`.

```
services:
  foo:
    image: alpine
    volumes:
    - bar:/data
volumes:
  bar:
    driver: rancher-nfs
    driver_opts:
      onRemove: retain
```

## Backwards Compatibility

For backwards compatibility, a volume may be configured to consume and NFS host/export pair. When configured in this manner, no subfolder is created; the root export directory is mounted. Example:

```
version: '2'
services:
  foo:
    image: alpine
    volumes:
    - bar:/data
volumes:
  bar:
    driver: rancher-nfs
    driver_opts:
      host: 172.22.101.100
      export: /
```

# Changelog

Changelog format inspired by [keepachangelog](http://keepachangelog.com/en/0.3.0/).

## [Unreleased]

## [0.4.0] - 2017-07-19

### Added

* New driver option `onRemove=retain|purge` to conditionally [preserve data](#preserve-data)
* NFS v3 support

### Changed

* Improve framework and driver logging

[Unreleased]: https://github.com/rancher/storage/compare/v0.8.4...master
[0.4.0]: https://github.com/rancher/storage/compare/v0.8.3...v0.8.4