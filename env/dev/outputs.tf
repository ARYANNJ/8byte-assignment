output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_name" {
  description = "The name of the VPC"
  value       = module.vpc.vpc_name
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = module.vpc.vpc_arn
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.vpc.public_subnet_ids
}

output "public_subnet_cidr_blocks" {
  description = "CIDR blocks of the public subnets"
  value       = module.vpc.public_subnet_cidr_blocks
}

output "public_subnet_names" {
  description = "Names of the public subnets"
  value       = module.vpc.public_subnet_names
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = module.vpc.private_subnet_ids
}

output "private_subnet_cidr_blocks" {
  description = "CIDR blocks of the private subnets"
  value       = module.vpc.private_subnet_cidr_blocks
}

output "private_subnet_names" {
  description = "Names of the private subnets"
  value       = module.vpc.private_subnet_names
}

output "public_route_table_id" {
  description = "The ID of the public route table"
  value       = module.vpc.public_route_table_id
}

output "public_route_table_arn" {
  description = "The ARN of the public route table"
  value       = module.vpc.public_route_table_arn
}

output "private_route_table_id" {
  description = "The ID of the private route table"
  value       = module.vpc.private_route_table_id
}

output "private_route_table_arn" {
  description = "The ARN of the private route table"
  value       = module.vpc.private_route_table_arn
}

output "internet_gateway_id" {
  description = "The ID of the internet gateway"
  value       = module.vpc.internet_gateway_id
}
output "app_url" {
  value = "http://${module.alb.alb_dns_name}"
}
output "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  value       = module.ecs_cluster.cluster_name
}
output "ecs_cluster_arn" {
  description = "The ARN of the ECS cluster"
  value       = module.ecs_cluster.cluster_arn
}


