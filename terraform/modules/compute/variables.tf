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

# Amazon Linux 2023 AMI for ap-southeast-1 (Singapore)
# If this ever gives an error, look up the latest ami-id in the console:
# EC2 -> Launch Instance -> search "Amazon Linux 2023"
variable "ami_id" {
  description = "Amazon Linux 2023 AMI for ap-southeast-1"
  type        = string
  default     = "ami-0df7a207adb9748c7"
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

# App environment variables — passed into the EC2 startup script
variable "db_host" {
  description = "RDS hostname (from rds module output: db_address)"
  type        = string
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
  description = "Secret key used to sign JWT tokens. Set this in terraform.tfvars (gitignored)."
  type        = string
  sensitive   = true
}

variable "github_repo_url" {
  description = "HTTPS URL of your GitHub repo, e.g. https://github.com/your-username/keypkey-cloud-project.git"
  type        = string
}

variable "frontend_url" {
  description = "URL of the frontend (S3 static site or CloudFront) — used for CORS. Set after Stage 4."
  type        = string
  default     = "*"
}
