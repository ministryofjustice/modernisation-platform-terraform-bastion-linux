locals {
  kms_key_arn = var.custom_s3_kms_arn != "" ? var.custom_s3_kms_arn : aws_kms_key.bastion_s3[0].arn

  linux_ami_sss_parameter = "ami-amazon-linux-latest/al2023-ami-kernel-6.1-x86_64"

}
