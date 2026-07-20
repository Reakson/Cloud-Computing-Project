variable "project_name" {
  type    = string
  default = "keypkey"
}

variable "environment" {
  description = "Used to keep the bucket name globally unique (e.g. dev)"
  type        = string
  default     = "dev"
}