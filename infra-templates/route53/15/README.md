## Route53 DNS

Rancher External DNS service powered by Amazon Route53

#### Changelog

##### v0.7.0

* Fix an issue for Cattle FQDN updates with custom name templates

#### Usage

##### Upgrade Notes
While upgrading from a version lower than v0.6.0 the TTL configuration value should not be changed. You may change it once the upgrade has been completed.

##### Limitation when running the service on multiple Rancher servers

When running multiple instances of the External DNS service configured to use the same domain name, then only one of them can run in the "Default" environment of a Rancher server instance.

##### Supported host labels

`io.rancher.host.external_dns_ip`     
Override the IP address used in DNS records for containers running on the host. Defaults to the IP address the host is registered with in Rancher.

`io.rancher.host.external_dns`    
Accepts 'true' (default) or 'false'    
When this is set to 'false' no DNS records will ever be created for containers running on this host.

##### Supported service labels

`io.rancher.service.external_dns`     
Accepts 'always', 'never' or 'auto' (default)  
- `always`: Always create DNS records for this service
- `never`: Never create DNS records for this service
- `auto`: Create DNS records for this service if it exposes ports on the host

`io.rancher.service.external_dns_name_template`
Override the DNS name template for specific services (see below)

##### Custom DNS name template

By default DNS entries are named `<service>.<stack>.<environment>.<domain>`.    
You can specify a custom name template used to construct the subdomain part (left of the domain/zone name) of the DNS records. The following placeholders are supported:

* `%{{service_name}}`
* `%{{stack_name}}`
* `%{{environment_name}}`

**Example:**

`%{{stack_name}}-%{{service_name}}.statictext`

Make sure to only use characters in static text and separators that your provider allows in DNS names.

##### Required AWS IAM permissions
The following IAM policy describes the minimum set of permissions needed for Route53 DNS to work.
Make sure that the AWS security credentials (Access Key ID / Secret Access Key) that you are specifying have been granted at least these permissions.

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "route53:GetHostedZone",
                "route53:GetHostedZoneCount",
                "route53:ListHostedZonesByName",
                "route53:ListResourceRecordSets"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "route53:ChangeResourceRecordSets"
            ],
            "Resource": [
                "arn:aws:route53:::hostedzone/<HOSTED_ZONE_ID>"
            ]
        }
    ]
}
```

Note: When using this JSON document to create a custom IAM policy in AWS, replace `<HOSTED_ZONE_ID>` with the ID of the Route53 hosted zone or use a wildcard ('*').
