variable "vpc_name" {
  type        = string
  description = "Name of the VPC"
}

variable "aws_region" {
  type        = string
  description = "AWS deployment region"
  default     = "ap-south-1" 
}

variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"   
}

variable "environment" {
  type        = string
  description = "Deployment environment"
}

variable "private_subnet_cidr_block" {
  type        = string
  description = "CIDR block for the subnet"
  default     = "10.0.1.0/24" 
}

variable "public_subnet_cidr_block" {
  type        = string
  description = "CIDR block for the public subnet"
  default     = "10.0.2.0/24" 
}


variable "availability_zone_one" {
  type        = string
  description = "Availability zone for the subnet"
  default     = "ap-south-1a" 
}
variable "availability_zone_two" {
  type        = string
  description = "Availability zone for the public subnet"
  default     = "ap-south-1b" 
}