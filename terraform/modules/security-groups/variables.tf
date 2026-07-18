variable "project_name" {
  type    = string
  default = "keypkey"
}

variable "vpc_id" {
  description = "VPC ID these security groups belong to"
  type        = string
}
