variable "name" {
  description = "Cluster name; also used as the prefix for related resources"
  type        = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  description = "Subnets for the ASG instances"
  type        = list(string)
}

variable "alb_sg_id" {
  description = "ALB security group allowed to reach the dynamic ports"
  type        = string
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "min_size" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 1
}

variable "associate_public_ip" {
  description = "true avoids NAT cost when using public subnets (SG still locks it down)"
  type        = bool
  default     = false
}

variable "container_insights" {
  type    = bool
  default = false
}

variable "tags" {
  type    = map(string)
  default = {}
}