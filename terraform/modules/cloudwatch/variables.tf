#new tra add all, cloudwatch stage 6
variable "project_name" {
  type    = string
  default = "keypkey"
}

variable "asg_name" {
  type = string
}

variable "alb_arn_suffix" {
  type = string
}

variable "target_group_arn_suffix" {
  type = string
}

variable "cpu_high_threshold" {
  type    = number
  default = 70
}

variable "cpu_low_threshold" {
  type    = number
  default = 30
}

variable "scale_out_policy_arn" {
  type = string
}

variable "scale_in_policy_arn" {
  type = string
}

variable "aws_region" {
  type    = string
  default = "ap-southeast-1"
}

variable "alarm_email" {
  type    = string
  default = ""
}