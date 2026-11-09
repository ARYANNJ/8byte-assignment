output "vpc_name" {
  description = "The name of the VPC"
  value       = module.vpc.vpc_Name
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = module.vpc.vpc_arn
}

output "private_subnet_id" {
  description = "The ID of the private subnet"
  value       = module.vpc.private_subnet_id
}

output "private_subnet_cidr_block" {
  description = "The CIDR block of the private subnet"
  value       = module.vpc.subnet_cidr_block
}

output "private_subnet_arn" {
  description = "The ARN of the private subnet"
  value       = module.vpc.subnet_arn
}

output "private_subnet_Name" {
  description = "The name of the private subnet"
  value       = module.vpc.private_subnet_Name
}

output "public_subnet_id" {
  description = "The ID of the public subnet"
  value       = module.vpc.public_subnet_one_id
}

output "private_route_table_id" {
  description = "The ID of the private route table"
  value       = module.vpc.private_route_table_id
}

output "private_route_table_arn" {
  description = "The ARN of the private route table"
  value       = module.vpc.private_route_table_arn
}

output "private_route_table_Name" {
  description = "The name of the private route table"
  value       = module.vpc.private_route_table_Name
}

output "public_route_table_id" {
  description = "The ID of the public route table"
  value       = module.vpc.public_route_table_id
}

output "public_route_table_arn" {
  description = "The ARN of the public route table"
  value       = module.vpc.public_route_table_arn
}

output "public_route_table_Name" {
  description = "The name of the public route table"
  value       = module.vpc.public_route_table_Name
}

output "internet_gateway_id" {
  description = "The ID of the internet gateway"
  value       = module.vpc.internet_gateway_id
}