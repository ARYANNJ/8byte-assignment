variable "alb_name" {
  description = "ALB name prefix (max 32 chars for the ALB name itself)"
  type        = string
}

variable "vpc_id" {
  type = string
}

variable "vpc_cidr" {
  description = "Used to scope ALB egress to the VPC only"
  type        = string
}

variable "public_subnet_ids" {
  description = "At least 2 subnets in different AZs (ALB requirement)"
  type        = list(string)
}

variable "certificate_arn" {
  description = "ACM cert ARN. If null, only an HTTP listener is created"
  type        = string
  default     = null
}

variable "allowed_ingress_cidrs" {
  description = "Who can reach the ALB"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "enable_deletion_protection" {
  description = "Keep false for a throwaway build so terraform destroy works"
  type        = bool
  default     = false
}

variable "tags" {
  type    = map(string)
  default = {}
}