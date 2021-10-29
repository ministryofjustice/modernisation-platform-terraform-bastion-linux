data "aws_instances" "ecs_instances_meta" {
  depends_on    = [aws_autoscaling_group.bastion_linux_daily]
  instance_tags = {
    Name = "bastion_linux"
  }
}

output "bastion_private_ip" {
  description = "Private IP of bastion"
  value       = data.aws_instances.ecs_instances_meta.private_ips[0]
}
