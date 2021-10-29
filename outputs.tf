data "aws_instances" "ecs_instances_meta" {
  instance_tags = {
    Name = "bastion_linux"
  }
}

output "bastion_private_ip" {
  description = "Private IP of bastion"
  value       = data.aws_instances.ecs_instances_meta.private_ips[0]
}
