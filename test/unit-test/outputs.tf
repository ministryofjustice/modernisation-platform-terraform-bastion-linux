output "bastion_security_group_1" {
  description = "Security group of bastion"
  value       = module.bastion_linux[0].bastion_security_group
}

output "bastion_launch_template_1" {
  description = "Launch template of bastion"
  value       = module.bastion_linux[0].bastion_launch_template
}

output "bastion_s3_bucket_1" {
  description = "S3 bucket of bastion"
  value       = module.bastion_linux[0].bastion_s3_bucket
}

output "bastion_security_group_2" {
  description = "Security group of bastion"
  value       = module.bastion_linux[1].bastion_security_group
}

output "bastion_launch_template_2" {
  description = "Launch template of bastion"
  value       = module.bastion_linux[1].bastion_launch_template
}

output "bastion_s3_bucket_2" {
  description = "S3 bucket of bastion"
  value       = module.bastion_linux[1].bastion_s3_bucket
}
