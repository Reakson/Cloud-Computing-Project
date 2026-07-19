variable "project_name" {
  type    = string
  default = "keypkey"
}

variable "ec2_sg_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "instance_profile_name" {
  type = string
}

variable "target_group_arn" {
  type = string
}

variable "instance_type" {
  description = "EC2 instance size"
  type        = string
  default     = "t3.micro"
}

variable "asg_min_size" {
  type    = number
  default = 2
}

variable "asg_max_size" {
  type    = number
  default = 4
}

variable "asg_desired_capacity" {
  type    = number
  default = 2
}

variable "db_host" {
  type = string
}

variable "db_name" {
  type    = string
  default = "keypkey"
}

variable "db_user" {
  type    = string
  default = "keypkey_admin"
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "jwt_secret" {
  type      = string
  sensitive = true
}

variable "vault_secret" {
  description = "Secret key used for AES-256 vault encryption. Set in terraform.tfvars (gitignored)."
  type        = string
  sensitive   = true
}

variable "github_repo_url" {
  type = string
}

variable "frontend_url" {
  type    = string
  default = "*"
}
