output "bastion_launch_template" {
  description = "Bastion launch templates"
  value       = { for idx, bastion in module.bastion_linux : "bastion_${idx}" => bastion.bastion_launch_template.id }
}

output "bastion_s3_bucket" {
  description = "Bastion S3 buckets"
  value       = { for idx, bastion in module.bastion_linux : "bastion_${idx}" => bastion.bastion_s3_bucket.bucket.id }
}

output "bastion_security_group" {
  description = "Bastion security groups"
  value       = { for idx, bastion in module.bastion_linux : "bastion_${idx}" => bastion.bastion_security_group_map.id }
}

output "bastion_kms_key" {
  description = "Bastion KMS keys"
  value       = { for idx, bastion in module.bastion_linux : "bastion_${idx}" => bastion.bastion_kms_key[0].id }
}
