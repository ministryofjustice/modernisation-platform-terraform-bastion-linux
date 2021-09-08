# Bastion Linux Server Creation

Terraform module for creating Linux bastion servers in member AWS accounts

## Usage

create file named 'bastion_linux.json' and populate with below format. Add user names and public ssh keys as requried.

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
  source = "github.com/ministryofjustice/modernisation-platform-terraform-bastion-linux?ref=v1.0.0"

  providers = {
    aws.share-host   = aws.core-vpc            # core-vpc-(environment) holds the networking for all accounts
    aws.share-tenant = aws                     # The default provider (unaliased, `aws`) is the tenant
  }

  # s3 - used for logs and user public keys
  bucket_name           = "bastion"
  bucket_versioning     = true
  bucket_force_destroy  = true
  # public keys
  public_key_data       = local.public_key_data.keys[local.environment]
  # logs
  log_auto_clean        = true
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

<!--- BEGIN_TF_DOCS --->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.47.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.47.0 |
| <a name="provider_aws.share-host"></a> [aws.share-host](#provider\_aws.share-host) | >= 3.47.0 |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_instance_profile.bastion_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.bastion_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.bastion_ssm_s3_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.bastion_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.bastion_host_ssm_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.bastion_managed](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.bastion_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_instance.bastion_linux](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_kms_alias.bastion_s3_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.bastion_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_s3_bucket.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_object.bucket_public_keys_readme](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object) | resource |
| [aws_s3_bucket_object.user_public_keys](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object) | resource |
| [aws_s3_bucket_public_access_block.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_security_group.bastion_linux](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.basion_linux_egress_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.basion_linux_egress_2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.basion_linux_egress_3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.basion_linux_egress_4](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.bastion_linux_egress_5](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_ami.linux_2_image](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_iam_policy_document.bastion_assume_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.bastion_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.bastion_ssm_s3_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_security_group.core_vpc_protected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |
| [aws_subnet.local_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_subnet.private_az_a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_subnet_ids.local_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet_ids) | data source |
| [aws_vpc.shared_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [aws_vpc_endpoint.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc_endpoint) | data source |
| [template_file.user_data](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_ssh_commands"></a> [allow\_ssh\_commands](#input\_allow\_ssh\_commands) | Allow SSH commands to be specified | `bool` | n/a | yes |
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | Name of application | `string` | n/a | yes |
| <a name="input_bucket_force_destroy"></a> [bucket\_force\_destroy](#input\_bucket\_force\_destroy) | The bucket and all objects should be destroyed when using true | `bool` | n/a | yes |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Bucket used for bucket log storage and user public keys | `string` | n/a | yes |
| <a name="input_bucket_versioning"></a> [bucket\_versioning](#input\_bucket\_versioning) | Enable bucket versioning or not | `bool` | n/a | yes |
| <a name="input_business_unit"></a> [business\_unit](#input\_business\_unit) | Fixed variable to specify business-unit for RAM shared subnets | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | application environment | `string` | n/a | yes |
| <a name="input_extra_user_data_content"></a> [extra\_user\_data\_content](#input\_extra\_user\_data\_content) | Extra user data content for Bastion ec2 | `string` | `""` | no |
| <a name="input_log_auto_clean"></a> [log\_auto\_clean](#input\_log\_auto\_clean) | Enable or not the lifecycle | `bool` | n/a | yes |
| <a name="input_log_expiry_days"></a> [log\_expiry\_days](#input\_log\_expiry\_days) | Number of days before logs expiration | `number` | n/a | yes |
| <a name="input_log_glacier_days"></a> [log\_glacier\_days](#input\_log\_glacier\_days) | Number of days before moving logs to Glacier | `number` | n/a | yes |
| <a name="input_log_standard_ia_days"></a> [log\_standard\_ia\_days](#input\_log\_standard\_ia\_days) | Number of days before moving logs to IA Storage | `number` | n/a | yes |
| <a name="input_public_key_data"></a> [public\_key\_data](#input\_public\_key\_data) | User public keys for specific environment | `any` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | #Main | `string` | n/a | yes |
| <a name="input_subnet_set"></a> [subnet\_set](#input\_subnet\_set) | Fixed variable to specify subnet-set for RAM shared subnets | `string` | n/a | yes |
| <a name="input_tags_common"></a> [tags\_common](#input\_tags\_common) | MOJ required tags | `map(string)` | n/a | yes |
| <a name="input_tags_prefix"></a> [tags\_prefix](#input\_tags\_prefix) | prefix for name tags | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bastion_private_ip"></a> [bastion\_private\_ip](#output\_bastion\_private\_ip) | Private IP of bastion |

<!--- END_TF_DOCS --->

## Looking for issues?
If you're looking to raise an issue with this module, please create a new issue in the [Modernisation Platform repository](https://github.com/ministryofjustice/modernisation-platform/issues).
