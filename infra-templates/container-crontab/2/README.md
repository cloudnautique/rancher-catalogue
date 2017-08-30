## Rancher Container Crontab
Starts, stops or restarts containers in your environment

### Usage

This service deploys globally, and listens on the Docker socket for start/create/destroy events. 
If the container is part of a service, container-crontab will verify that the service is in an
`active` state. If it isn't the job will be ignored. Keep in mind that services that are waiting
for upgrade confirmation, will not have cron jobs run.
To automatically have your container started every 5 minutes, add the label:

`cron.schedule="0 0-59/5 * * * ?"`

To your container. See [robfig/cron](https://godoc.org/github.com/robfig/cron) docs for schedule rules.

To override the default action `start` you can apply the label:

`cron.action` to either `stop` or `restart`

The default restart_timeout is `10 seconds` to override apply the label:

`cron.restart_timeout` in seconds

_Note_ *the restart_timeout also applys to `stop` action.
