output "bastion_security_group" {
  value       = module.bastion_linux.bastion_security_group
  description = "Security group of bastion"
}
