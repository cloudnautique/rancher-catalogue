# Rancher Garbage Collection Manager

Rancher Garbage Collection Manager to collect unused resources on the host. (currently only support docker images collection)

### Usage

Rancher Garbage Collection Manager is deployed as a micro service. It will detect disk usage periodically and if disk usage is above the high threshold the garbage collection will be triggered. Garbage Manager will delete least recently unused images until the low threshold has been met.

### Configuration Parameters

Rancher Garbage Collection Manager uses the following environment variables to define the parameters:

`IMAGE_GC_HIGH_THRESHOLD` : The percent of disk usage which triggers image garbage collection. Default(90%)

`IMAGE_GC_LOW_THRESHOLD` : The percent of disk usage to which image garbage collection attempts to free. Default(80%)

`IMAGE_GC_MIN_AGE` : The minimum age an image can be garbage collected from the first detected time. Default(5 minutes)

`IMAGE_GC_INTERVAL` : Image Garbage Collection Interval. Default(5 minutes)