variable "rds_name" {
  description = "Name prefix (e.g. dev)"
  type        = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  description = "At least 2 subnets in different AZs (RDS subnet group requirement)"
  type        = list(string)
}

variable "allowed_sg_id" {
  description = "Security group allowed to connect on 5432 (the ECS instance SG)"
  type        = string
}

variable "db_name" {
  type    = string
  default = "appdb"
}

variable "master_username" {
  type    = string
  default = "dbadmin"
}

variable "engine_version" {
  type    = string
  default = "16"
}

variable "instance_class" {
  type    = string
  default = "db.t4g.micro"
}

variable "allocated_storage" {
  type    = number
  default = 20
}

variable "multi_az" {
  type    = bool
  default = false
}

variable "backup_retention_days" {
  type    = number
  default = 1
}

variable "deletion_protection" {
  description = "Keep false for a throwaway build so terraform destroy works"
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  type    = bool
  default = true
}

variable "tags" {
  type    = map(string)
  default = {}
}