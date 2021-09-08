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

## Looking for issues?
If you're looking to raise an issue with this module, please create a new issue in the [Modernisation Platform repository](https://github.com/ministryofjustice/modernisation-platform/issues).

## Linting exclusions

- `checkov_exclude: CKV_AWS_144` (Ensure S3 bucket has cross-region replication enabled): Enabling cross-region replication for the bastion module might be an overkill. This seems more like a best practice to make Jeff Bezos richer. Looking at the use cases provided by Amazon https://aws.amazon.com/s3/features/replication/ none of them seems relevant to our bastion logs. Besides, the checkov_exclude: CKV_AWS_144 needs to be in place anyway because checkov will require replication for the replication bucket as it cannot separate it from the regular non-replication bucket. If in the future we do decide to enable cross-region replication we should use the following terraform module, which supports cross-region replication as an optional configuration: https://github.com/ministryofjustice/modernisation-platform-terraform-s3-bucket
