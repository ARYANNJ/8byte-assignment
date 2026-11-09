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

output "vpc_Name" {
  description = "The name of the VPC"
  value       = aws_vpc.main.tags["Name"]
}

output "private_subnet_id" {
  description = "The ID of the subnet"
  value       = aws_subnet.private-subnet.id
}

output "subnet_cidr_block" {
  description = "The CIDR block of the subnet"
  value       = aws_subnet.private-subnet.cidr_block
}

output "subnet_arn" {
  description = "The ARN of the subnet"
  value       = aws_subnet.private-subnet.arn
}

output "private_subnet_Name" {
  description = "The name of the subnet"
  value       = aws_subnet.private-subnet.tags["Name"]
}

output "public_subnet_id" {
  description = "The ID of the public subnet"
  value       = aws_subnet.public-subnet.id
}

output "private_route_table_id" {
  description = "The ID of the route table"
  value       = aws_route_table.private-route-table.id
}

output "private_route_table_arn" {
  description = "The ARN of the route table"
  value       = aws_route_table.private-route-table.arn
}

output "private_route_table_Name" {
  description = "The name of the route table"
  value       = aws_route_table.private-route-table.tags["Name"]
}

output "public_route_table_id" {
  description = "The ID of the route table"
  value       = aws_route_table.public.id
}

output "public_route_table_arn" {
  description = "The ARN of the route table"
  value       = aws_route_table.public.arn
}

output "public_route_table_Name" {
  description = "The name of the route table"
  value       = aws_route_table.public.tags["Name"]
}

output "internet_gateway_id" {
  description = "The ID of the internet gateway"
  value       = aws_internet_gateway.main-igw.id
}