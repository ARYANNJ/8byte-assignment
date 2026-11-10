output "cluster_id"          { value = aws_ecs_cluster.this.id }
output "cluster_name"        { value = aws_ecs_cluster.this.name }
output "cluster_arn"         { value = aws_ecs_cluster.this.arn }
output "instance_sg_id"      { value = aws_security_group.instance.id }
output "capacity_provider"   { value = aws_ecs_capacity_provider.this.name }
output "instance_role_arn"   { value = aws_iam_role.instance.arn }