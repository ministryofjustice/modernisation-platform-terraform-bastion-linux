output "bastion_security_group" {
  description = "Security group of bastion"
  value       = aws_security_group.bastion_linux.id
}

output "bastion_launch_template" {
  description = "Launch template of bastion"
  value       = aws_launch_template.bastion_linux_template
}

output "bastion_s3_bucket" {
  description = "S3 bucket of bastion"
  value       = module.s3-bucket
}

output "bastion_iam_role" {
  description = "IAM role of bastion"
  value       = aws_iam_role.bastion_role
}

output "bastion_kms_key" {
  value = aws_kms_key.bastion_s3
}

output "bastion_kms_key_alias" {
  value = aws_kms_alias.bastion_s3
}