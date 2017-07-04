## Route53 DNS

Rancher External DNS service powered by Amazon Route53

#### Changelog

##### v0.6.0

* Reduces the overall rate of API requests to the DNS provider
* Adds support for custom DNS naming convention
* Stack, service and environment names used in service DNS names are now sanitized to conform with RFC 1123. Characters other than `a-z`, `A-Z`, `0-9` or `dash` are replaced by dashes.
* For internal use the service creates TXT records to track the FQDNs it manages. These TXT records are named `external-dns-<environemntUUID>.<domain>` and should not be deleted.

#### Usage

##### Upgrade Notes
While upgrading from a version lower than v0.6.0 the TTL configuration value should not be changed. You may change it once the upgrade has been completed.

##### Limitation when running the service on multiple Rancher servers

When running multiple instances of the External DNS service configured to use the same domain name, then only one of them can run in the "Default" environment of a Rancher server instance.

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