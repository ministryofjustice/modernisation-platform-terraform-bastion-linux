locals {
  kms_key_arn = var.custom_s3_kms_arn != "" ? var.custom_s3_kms_arn : aws_kms_key.bastion_s3[0].arn
}
