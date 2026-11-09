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
  source                        = "../../modules/vpc"
  vpc_name                      = var.vpc_name
  vpc_cidr_block                = var.vpc_cidr_block
  private_subnet_cidr_block_one = var.private_subnet_cidr_block_one
  public_subnet_cidr_block_one  = var.public_subnet_cidr_block_one
  private_subnet_cidr_block_two = var.private_subnet_cidr_block_two
  public_subnet_cidr_block_two  = var.public_subnet_cidr_block_two
  environment                   = var.environment
  aws_region                    = var.aws_region
  availability_zone_one         = var.availability_zone_one
  availability_zone_two         = var.availability_zone_two
}