# Bastion Linux Server Creation

[![repo standards badge](https://img.shields.io/endpoint?labelColor=231f20&color=005ea5&style=for-the-badge&label=MoJ%20Compliant&url=https%3A%2F%2Foperations-engineering-reports.cloud-platform.service.justice.gov.uk%2Fapi%2Fv1%2Fcompliant_public_repositories%2Fendpoint%2Fmodernisation-platform-terraform-bastion-linux&logo=data:image/png;base64,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)](https://operations-engineering-reports.cloud-platform.service.justice.gov.uk/public-report/modernisation-platform-terraform-bastion-linux)

Terraform module for creating Linux bastion servers in member AWS accounts

## Usage

create file named 'bastion_linux.json' and populate with below format. Add user names and public ssh keys as required.

```json
{
    "keys": {
        "development": {
            "username1": "public key data ~~~~~~~~~~~~~~~",
            "username2": "public key data ~~~~~~~~~~~~~~~"
        },
        "test": {
            "username1": "public key data ~~~~~~~~~~~~~~~",
            "username2": "public key data ~~~~~~~~~~~~~~~"
        },
        "preproduction": {
            "username1": "public key data ~~~~~~~~~~~~~~~",
            "username2": "public key data ~~~~~~~~~~~~~~~"
        },
        "production": {
            "username1": "public key data ~~~~~~~~~~~~~~~",
            "username2": "public key data ~~~~~~~~~~~~~~~"
        }
    }
}
```

create a bastion_linux.tf file as below, change options as required
```terraform
locals {
  public_key_data = jsondecode(file("./bastion_linux.json"))
}

module "bastion_linux" {
  source = "github.com/ministryofjustice/modernisation-platform-terraform-bastion-linux?ref=v3.0.4"

  providers = {
    aws.share-host   = aws.core-vpc            # core-vpc-(environment) holds the networking for all accounts
    aws.share-tenant = aws                     # The default provider (unaliased, `aws`) is the tenant
  }

  # s3 - used for logs and user public keys
  bucket_name           = "bastion"
  # public keys
  public_key_data       = local.public_key_data.keys[local.environment]
  # logs
  log_auto_clean        = "Enabled"
  log_standard_ia_days  = 30    # days before moving to IA storage
  log_glacier_days      = 60    # days before moving to Glacier
  log_expiry_days       = 180   # days before log expiration
  # bastion
  allow_ssh_commands    = false

  app_name              = var.networking[0].application
  business_unit         = local.vpc_name
  subnet_set            = local.subnet_set
  environment           = local.environment
  region                = "eu-west-2"

  # Tags
  tags_common = local.tags
  tags_prefix = terraform.workspace
}
```

#### Note:
Passing in a custom KMS key? You'll need to make sure the bastion iam role has permissions to use it.
See `aws_kms_key_policy.bastion_s3` in `main.tf` for an example.
This module ouputs the bastion iam role object (see `outputs.tf`), so you can use it in your own policy.

## Looking for issues?
If you're looking to raise an issue with this module, please create a new issue in the [Modernisation Platform repository](https://github.com/ministryofjustice/modernisation-platform/issues).

## Linting exclusions

- `checkov_exclude: CKV_AWS_144` (Ensure S3 bucket has cross-region replication enabled): Enabling cross-region replication for the bastion module might be an overkill. Looking at the use cases provided by Amazon https://aws.amazon.com/s3/features/replication/ none of them seems relevant to our bastion logs. Besides, the checkov_exclude: CKV_AWS_144 needs to be in place anyway because checkov will require replication for the replication bucket as it cannot separate it from the regular non-replication bucket. If in the future we do decide to enable cross-region replication we should use the following terraform module, which supports cross-region replication as an optional configuration: https://github.com/ministryofjustice/modernisation-platform-terraform-s3-bucket
- `checkov_exclude: CKV_AWS_18` (Ensure the S3 bucket has access logging enabled), `tfsec_exclude: AWS002` (Resource 'aws_s3_bucket.default' does not have logging enabled): After a discussion with the team we decided not to enable server access logging for the S3 bucket. The S3 bucket is only used by the bastion server and will not be accessed directly. Therefore, access logs are not important. If in the future we do decide to enable server access logging, we should use the following terraform module, setting the `log_bucket` configuration option: https://github.com/ministryofjustice/modernisation-platform-terraform-s3-bucket

## S3 bucket versioning notes (for developers)

We have S3 versioning enabled in bastion not as much for versioning but more so to allow recovering logs that are accidentally deleted.

We record every SSH session into a separate file named using the current time rounded to the minute. Then, every 10 minutes we copy log files to S3 and delete log files that are older than a day. Deleting log files older than a day is simply a way to clear the local ephemeral storage (also cleared upon restart). Since older logs are already stored in S3 and we don't provide the `-delete` option into the `aws s3 sync` command, they will be retrievable from S3.

We also have S3 lifecycle management configured to gradually transition logs to cheaper storage. Therefore, logs remain in S3 for 30 days before moving to IA (Infrequent Access) storage. After 60 days they move to Glacier and after 180 days they expire and are permanently deleted.

In order to prevent older versions from being retained forever, in addition to the lifecycle policy for the current version we also configure a separate lifecycle policy for noncurrent versions. Otherwise, older versions would never be moved to cheaper storage and would never be expired/deleted. We use the S3 bucket module for this which allows both current and noncurrent version lifecycle management.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |
| <a name="provider_aws.share-host"></a> [aws.share-host](#provider\_aws.share-host) | ~> 5.0 |
| <a name="provider_random"></a> [random](#provider\_random) | ~> 3.4 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_s3-bucket"></a> [s3-bucket](#module\_s3-bucket) | github.com/ministryofjustice/modernisation-platform-terraform-s3-bucket | 568694e50e03630d99cb569eafa06a0b879a1239 |

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_group.bastion_linux_daily](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_autoscaling_schedule.bastion_linux_scale_down](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_schedule) | resource |
| [aws_autoscaling_schedule.bastion_linux_scale_up](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_schedule) | resource |
| [aws_iam_instance_profile.bastion_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.bastion_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.bastion_ssm_s3_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.bastion_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.bastion_host_ssm_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.bastion_managed](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.bastion_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.bastion_s3_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.bastion_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_key_policy.bastion_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key_policy) | resource |
| [aws_launch_template.bastion_linux_template](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_s3_object.bucket_public_keys_readme](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_s3_object.user_public_keys](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_security_group.bastion_linux](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.bastion_linux_egress_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.bastion_linux_egress_2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.bastion_linux_egress_3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [random_string.random6](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_ami.linux_2_image](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.bastion_assume_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.bastion_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.bastion_ssm_s3_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_security_group.core_vpc_protected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |
| [aws_subnet.local_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_subnet.private_az_a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_subnets.local_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.shared_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [aws_vpc_endpoint.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc_endpoint) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_ssh_commands"></a> [allow\_ssh\_commands](#input\_allow\_ssh\_commands) | Allow SSH commands to be specified | `bool` | n/a | yes |
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | Name of application | `string` | n/a | yes |
| <a name="input_autoscaling_cron"></a> [autoscaling\_cron](#input\_autoscaling\_cron) | Cron expressions for scale up and scale down | `map(string)` | <pre>{<br>  "down": "0 20 * * *",<br>  "up": "0 5 * * *"<br>}</pre> | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Bucket used for bucket log storage and user public keys | `string` | n/a | yes |
| <a name="input_business_unit"></a> [business\_unit](#input\_business\_unit) | Fixed variable to specify business-unit for RAM shared subnets | `string` | n/a | yes |
| <a name="input_custom_s3_kms_arn"></a> [custom\_s3\_kms\_arn](#input\_custom\_s3\_kms\_arn) | KMS ARN for S3 bucket encryption | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | application environment | `string` | n/a | yes |
| <a name="input_extra_user_data_content"></a> [extra\_user\_data\_content](#input\_extra\_user\_data\_content) | Extra user data content for Bastion ec2 | `string` | `""` | no |
| <a name="input_instance_name"></a> [instance\_name](#input\_instance\_name) | Name of instance | `string` | `"bastion_linux"` | no |
| <a name="input_log_auto_clean"></a> [log\_auto\_clean](#input\_log\_auto\_clean) | Enable or not the lifecycle | `string` | n/a | yes |
| <a name="input_log_expiry_days"></a> [log\_expiry\_days](#input\_log\_expiry\_days) | Number of days before logs expiration | `number` | n/a | yes |
| <a name="input_log_glacier_days"></a> [log\_glacier\_days](#input\_log\_glacier\_days) | Number of days before moving logs to Glacier | `number` | n/a | yes |
| <a name="input_log_standard_ia_days"></a> [log\_standard\_ia\_days](#input\_log\_standard\_ia\_days) | Number of days before moving logs to IA Storage | `number` | n/a | yes |
| <a name="input_public_key_data"></a> [public\_key\_data](#input\_public\_key\_data) | User public keys for specific environment | `map(any)` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | #Main | `string` | n/a | yes |
| <a name="input_subnet_set"></a> [subnet\_set](#input\_subnet\_set) | Fixed variable to specify subnet-set for RAM shared subnets | `string` | n/a | yes |
| <a name="input_tags_common"></a> [tags\_common](#input\_tags\_common) | MOJ required tags | `map(string)` | n/a | yes |
| <a name="input_tags_prefix"></a> [tags\_prefix](#input\_tags\_prefix) | prefix for name tags | `string` | n/a | yes |
| <a name="input_volume_size"></a> [log\_volume\_size](#input\_volume\_size) | Size of the volume in gibibytes (GiB | `number` | 8 | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bastion_iam_role"></a> [bastion\_iam\_role](#output\_bastion\_iam\_role) | IAM role of bastion |
| <a name="output_bastion_launch_template"></a> [bastion\_launch\_template](#output\_bastion\_launch\_template) | Launch template of bastion |
| <a name="output_bastion_s3_bucket"></a> [bastion\_s3\_bucket](#output\_bastion\_s3\_bucket) | S3 bucket of bastion |
| <a name="output_bastion_security_group"></a> [bastion\_security\_group](#output\_bastion\_security\_group) | Security group of bastion |
<!-- END_TF_DOCS -->
