output "bastion_security_group" {
  description = "Security group of bastion"
  value       = aws_security_group.bastion_linux.id
}
