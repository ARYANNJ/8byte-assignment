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

module "alb" {
  source            = "../../modules/alb"
  alb_name          = var.alb_name
  vpc_id            = module.vpc.vpc_id
  vpc_cidr          = module.vpc.vpc_cidr_block
  public_subnet_ids = module.vpc.public_subnet_ids
  certificate_arn   = null
}

module "ecs_cluster" {
  source              = "../../modules/ecs-cluster"
  ecs_cluster_name    = "dev-ecs-cluster"
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.vpc.private_subnet_ids
  alb_sg_id           = module.alb.alb_sg_id
  instance_type       = "t3.micro"
  min_size            = 1
  max_size            = 1
  associate_public_ip = false
  container_insights  = false
  tags = {
    Environment = "dev"
    ManagedBy   = "Terraform"
    Project     = "Infrastructure"
  }
}

module "ecr" {
  source   = "../../modules/ecr"
  ecr_name = "dev-app"
}

module "rds" {
  source             = "../../modules/rds"
  rds_name           = "dev-rds"
  db_name            = "devdb"
  master_username    = "admin"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  allowed_sg_id      = module.ecs_cluster.instance_sg_id
}