variable "ecr_name" {
  description = "Repository name (e.g. dev-app)"
  type        = string
}

variable "max_image_count" {
  description = "Keep only the newest N images to limit storage cost"
  type        = number
  default     = 5
}

variable "force_delete" {
  description = "Allow terraform destroy even if images exist"
  type        = bool
  default     = true
}

variable "tags" {
  type    = map(string)
  default = {}
}