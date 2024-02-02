locals {
  kms_key_arn = try(var.custom_s3_kms_arn, false) ? var.custom_s3_kms_arn : aws_kms_key.bastion_s3[0].arn
}
