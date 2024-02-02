locals {
  kms_key_arn = length(var.custom_s3_kms_arn) > 1 ? [var.custom_s3_kms_arn] : [aws_kms_key.bastion_s3[0].arn]
}
