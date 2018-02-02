## Healthcheck

This stack provides a healthcheck service

### Changelog for v0.3.3-1
* Add re-initializing and initializing timeouts for the healthcheck service 

#### Healthcheck [rancher/healthcheck:v0.3.3]
* Added health check for sidekick service containers using networkFrom primary
* Changed to use Rancher Metadata IP directly to avoid name resolution
