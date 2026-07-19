variable "project_name" {
  type    = string
  default = "keypkey"
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  description = "Public subnets for the ALB (must be internet-facing)"
  type        = list(string)
}

variable "alb_sg_id" {
  type = string
}
