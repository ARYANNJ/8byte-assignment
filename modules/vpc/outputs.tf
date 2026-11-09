output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = aws_vpc.main.arn
}

output "vpc_name" {
  description = "The name of the VPC"
  value       = aws_vpc.main.tags["Name"]
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = [aws_subnet.public-subnet-one.id, aws_subnet.public-subnet-two.id]
}

output "public_subnet_cidr_blocks" {
  description = "CIDR blocks of the public subnets"
  value       = [aws_subnet.public-subnet-one.cidr_block, aws_subnet.public-subnet-two.cidr_block]
}

output "public_subnet_arns" {
  description = "ARNs of the public subnets"
  value       = [aws_subnet.public-subnet-one.arn, aws_subnet.public-subnet-two.arn]
}

output "public_subnet_names" {
  description = "Names of the public subnets"
  value       = [aws_subnet.public-subnet-one.tags["Name"], aws_subnet.public-subnet-two.tags["Name"]]
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = [aws_subnet.private-subnet-one.id, aws_subnet.private-subnet-two.id]
}

output "private_subnet_cidr_blocks" {
  description = "CIDR blocks of the private subnets"
  value       = [aws_subnet.private-subnet-one.cidr_block, aws_subnet.private-subnet-two.cidr_block]
}

output "private_subnet_arns" {
  description = "ARNs of the private subnets"
  value       = [aws_subnet.private-subnet-one.arn, aws_subnet.private-subnet-two.arn]
}

output "private_subnet_names" {
  description = "Names of the private subnets"
  value       = [aws_subnet.private-subnet-one.tags["Name"], aws_subnet.private-subnet-two.tags["Name"]]
}

output "public_route_table_id" {
  description = "The ID of the public route table"
  value       = aws_route_table.public.id
}

output "public_route_table_arn" {
  description = "The ARN of the public route table"
  value       = aws_route_table.public.arn
}

output "private_route_table_id" {
  description = "The ID of the private route table"
  value       = aws_route_table.private-route-table.id
}

output "private_route_table_arn" {
  description = "The ARN of the private route table"
  value       = aws_route_table.private-route-table.arn
}

output "internet_gateway_id" {
  description = "The ID of the internet gateway"
  value       = aws_internet_gateway.main-igw.id
}

output "internet_gateway_arn" {
  description = "The ARN of the internet gateway"
  value       = aws_internet_gateway.main-igw.arn
}