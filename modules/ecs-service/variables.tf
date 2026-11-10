variable "name" {
  description = "Service name, used as a prefix (e.g. dev-app)"
  type        = string
}

variable "cluster_id" {
  type = string
}

variable "capacity_provider" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "listener_arn" {
  type = string
}

variable "image" {
  description = "Full image URI, e.g. <ecr_repository_url>:latest"
  type        = string
}

variable "container_port" {
  type    = number
  default = 8000
}

variable "cpu" {
  type    = number
  default = 256
}

variable "memory" {
  description = "Hard memory limit in MiB. A t3.micro has about 800 MiB usable"
  type        = number
  default     = 384
}

variable "desired_count" {
  type    = number
  default = 1
}

variable "health_check_path" {
  type    = string
  default = "/health"
}

variable "path_pattern" {
  type    = string
  default = "/*"
}

variable "listener_rule_priority" {
  type    = number
  default = 100
}

variable "db_secret_arn" {
  description = "Secrets Manager ARN of the RDS-managed master secret"
  type        = string
}

variable "environment_variables" {
  description = "Plain (non-secret) env vars, e.g. DB_HOST, DB_PORT, DB_NAME"
  type        = map(string)
  default     = {}
}

variable "log_retention_days" {
  type    = number
  default = 7
}

variable "tags" {
  type    = map(string)
  default = {}
}