## Route53 DNS

#### Rancher External DNS service powered by Amazon Route53

This IAM policy describes the minimum permissions required for this service. Replace `<HOSTED_ZONE_ID>` with the ID of the hosted zone.

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "route53:GetChange",
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