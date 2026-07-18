variable "aws_region" {
  type    = string
  default = "ap-southeast-1"
}

variable "project_name" {
  type    = string
  default = "keypkey"
}

variable "db_password" {
  description = "Master password for the RDS instance. Set this in a terraform.tfvars file (gitignored) or via TF_VAR_db_password env var — never commit a real value here."
  type        = string
  sensitive   = true
}
