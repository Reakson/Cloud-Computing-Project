variable "aws_region" {
  type    = string
  default = "ap-southeast-1"
}

variable "project_name" {
  type    = string
  default = "keypkey"
}

variable "db_password" {
  description = "Master password for the RDS instance. Set in terraform.tfvars (gitignored)."
  type        = string
  sensitive   = true
}

variable "jwt_secret" {
  description = "Secret key for signing JWT tokens. Set in terraform.tfvars (gitignored)."
  type        = string
  sensitive   = true
}

variable "vault_secret" {
  description = "Secret key for vault encryption. Set in terraform.tfvars (gitignored)."
  type        = string
  sensitive   = true
}

variable "github_repo_url" {
  description = "HTTPS URL of your GitHub repo, e.g. https://github.com/your-username/keypkey-cloud-project.git"
  type        = string
}

#new tra add all, cloudwatch stage 6

variable "cpu_high_threshold" {
  type    = number
  default = 70
}

variable "cpu_low_threshold" {
  type    = number
  default = 30
}

variable "alarm_email" {
  type    = string
  default = ""
}