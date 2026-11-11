variable "name" {
  type = string
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

variable "image" {
  type = string
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
  description = "Hard memory limit in MiB"
  type        = number
  default     = 384
}

variable "desired_count" {
  type    = number
  default = 1
}

variable "network_mode" {
  description = "bridge (dynamic ports, used by the app) or host (fixed ports, used by monitoring)"
  type        = string
  default     = "bridge"
}

variable "host_port" {
  description = "Bridge mode only; 0 means dynamic"
  type        = number
  default     = 0
}

# ---------- ALB (optional) ----------
variable "enable_alb" {
  type    = bool
  default = true
}

variable "listener_arn" {
  type    = string
  default = null
}

variable "path_patterns" {
  type    = list(string)
  default = ["/*"]
}

variable "listener_rule_priority" {
  type    = number
  default = 100
}

variable "health_check_path" {
  type    = string
  default = "/health"
}

variable "allowed_cidrs" {
  description = "If set, the listener rule only matches these source IPs"
  type        = list(string)
  default     = []
}

# ---------- Secrets (optional) ----------
variable "enable_db_secret" {
  type    = bool
  default = true
}

variable "db_secret_arn" {
  type    = string
  default = null
}

variable "secrets" {
  description = "ENV_NAME => full Secrets Manager or SSM parameter ARN"
  type        = map(string)
  default     = {}
}

variable "secret_arns" {
  description = "ARNs the execution role may read (the targets of var.secrets)"
  type        = list(string)
  default     = []
}

# ---------- Other ----------
variable "environment_variables" {
  type    = map(string)
  default = {}
}

variable "command" {
  type    = list(string)
  default = []
}

variable "volumes" {
  description = "Docker volume name => container path (persists across task restarts, not instance replacement)"
  type        = map(string)
  default     = {}
}

variable "task_policy_arns" {
  description = "Managed policies to attach to the task role"
  type        = list(string)
  default     = []
}

variable "log_retention_days" {
  type    = number
  default = 7
}

variable "tags" {
  type    = map(string)
  default = {}
}