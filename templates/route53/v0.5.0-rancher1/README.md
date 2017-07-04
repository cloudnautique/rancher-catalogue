## Route53 DNS

Rancher External DNS service powered by Amazon Route53

#### Required AWS IAM permissions
The following IAM policy describes the minimum set of permissions needed for Route53 DNS to work.
Make sure that the AWS security credentials (Access Key ID / Secret Access Key) that you are providing in the template have been granted these permissions.

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
