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
  master_username    = "appadmin"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  allowed_sg_id      = module.ecs_cluster.instance_sg_id
}

module "service" {
  source = "../../modules/ecs-service"

  name              = "dev-app"
  cluster_id        = module.ecs_cluster.cluster_id
  capacity_provider = module.ecs_cluster.capacity_provider
  vpc_id            = module.vpc.vpc_id
  listener_arn      = module.alb.listener_arn

  image          = "${module.ecr.repository_url}:latest"
  container_port = 8000

  db_secret_arn = module.rds.secret_arn
  environment_variables = {
    DB_PORT = "5432"
    DB_NAME = "postgres"
    DB_HOST = module.rds.address
  }


}

module "monitoring_cluster" {
  source              = "../../modules/ecs-cluster"
  ecs_cluster_name    = "dev-monitoring-cluster"
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.vpc.private_subnet_ids
  alb_sg_id           = module.alb.alb_sg_id
  instance_type       = "t3.small" # 2 GiB, see note below
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

# module "ecr_grafana" {
#   source   = "../../modules/ecr"
#   ecr_name = "dev-grafana"
# }

# module "ecr_loki" {
#   source   = "../../modules/ecr"
#   ecr_name = "dev-loki"
# }

# module "ecr_prometheus" {
#   source   = "../../modules/ecr"
#   ecr_name = "dev-prometheus"
# }

# module "grafana" {
#   source            = "../../modules/ecs-service"
#   name              = "dev-grafana"
#   cluster_id        = module.monitoring_cluster.cluster_id
#   capacity_provider = module.monitoring_cluster.capacity_provider
#   vpc_id            = module.vpc.vpc_id
#   image             = "${module.ecr_grafana.repository_url}:latest"

#   network_mode     = "host"
#   container_port   = 3000
#   memory           = 256
#   enable_db_secret = false   # <- missing on your Grafana call

#   enable_alb             = true
#   listener_arn           = module.alb.listener_arn
#   listener_rule_priority = 10
#   path_patterns          = ["/grafana", "/grafana/*"]
#   health_check_path      = "/grafana/api/health"
# }

# module "loki" {
#   source            = "../../modules/ecs-service"
#   name              = "dev-loki"
#   cluster_id        = module.monitoring_cluster.cluster_id
#   capacity_provider = module.monitoring_cluster.capacity_provider
#   vpc_id            = module.vpc.vpc_id
#   image             = "${module.ecr_loki.repository_url}:latest"
#   container_port    = 3100
# }

# module "prometheus" {
#   source            = "../../modules/ecs-service"
#   name              = "dev-prometheus"
#   cluster_id        = module.monitoring_cluster.cluster_id
#   capacity_provider = module.monitoring_cluster.capacity_provider
#   vpc_id            = module.vpc.vpc_id
#   image             = "${module.ecr_prometheus.repository_url}:latest"

#   network_mode     = "host"
#   container_port   = 9090
#   memory           = 512
#   enable_alb       = false   
#   enable_db_secret = false   
# }