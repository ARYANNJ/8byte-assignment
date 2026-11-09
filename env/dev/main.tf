provider "aws" {
  region = "ap-south-1"

  default_tags {
    tags = {
      Environment = "dev"
      ManagedBy   = "Terraform"
      Project     = "Infrastructure"
    }
  }
}

module "vpc" {
  source = "../../modules/vpc"
    vpc_name                  = var.vpc_name
    vpc_cidr_block            = var.vpc_cidr_block
    private_subnet_cidr_block  = var.private_subnet_cidr_block
    public_subnet_cidr_block   = var.public_subnet_cidr_block
    availability_zone         = var.availability_zone
    environment               = var.environment
    aws_region                = var.aws_region
}