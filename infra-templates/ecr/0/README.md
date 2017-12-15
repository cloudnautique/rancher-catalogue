# Rancher ECR Credentials Updater

A Docker service that will update the Docker registry
credentials in Rancher for an Amazon Elastic Container Registry (ECR).

Originally contributed by John Engelman from [Object Partners](http://www.objectpartners.com).

## Why is this needed?

ECR is controlled with AWS IAM and registries in Rancher are verified using credentials (i.e. username and password). These credentials expire every 12 hours and need to be constantly updated. 

> **Note:** This application runs on a 6 hour loop. There is a possibility where there could be a slight gap where the credentials expire before this program updates them.

## How to use

In order to authenticate with AWS ECR, this Docker service uses the default
chain of [credential providers](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html#config-settings-and-precedence).

The only requirement for running this application is to specify the AWS region using the `AWS_REGION` environment variable.

AWS credentials are loaded using the default [AWS credential chain](http://docs.aws.amazon.com/sdk-for-go/latest/v1/developerguide/configuring-sdk.title.html).
Credentials are loaded in the following order:

1. Environment variables (Specify `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`, `AWS_SESSION_TOKEN` *(optional)*)
1. Shared credentials file (mount a volume to `/root/.aws` that contains `credentials` and `config` files and specify `AWS_PROFILE`)
1. IAM Instance Profile (if running on EC2)

> **Note:** Cross account roles are not currently supported.

## Notes

The AWS credentials must correspond to an IAM user that has permissions to call the ECR `GetToken` API. The application will parse the resulting response to retrieve the ECR registry URL, username, and password. The returned registry URL, is used to discover the corresponding registry in Rancher.
