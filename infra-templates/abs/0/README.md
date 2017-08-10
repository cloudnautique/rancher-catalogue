## Rancher ABS

### Default Configuration

By default, when you using `rancher-abs` as volume driver, `rancher-abs` will help you to **create** a [5GB cloud](https://help.aliyun.com/document_detail/25513.html) disk. And after create successfully, `rancher-abs` will **format** the new disk by `mkfs.ext4`. 

**Notification!!!** When you try to delete some applications, services or containers which are using the Aliyun's block storage created by `rancher-abs`, please don't expect `rancher-abs` will help you to release the disk, you must do it yourself if you want.

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
    driver: rancher-abs
```

### Custom Configuration

If you are going to customize the block storage, you can pass some parameter pairs by `driver_opts`. Those supported pairs have already listed as below,  you can take more details from [here](https://help.aliyun.com/document_detail/25513.html).

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
    driver: rancher-abs
    driver_opts:
      diskName: <a name for disk>
      size: <5GB default>
      diskCategory: <cloud default>
      snapshot_id: <disk snapshot id>
```
