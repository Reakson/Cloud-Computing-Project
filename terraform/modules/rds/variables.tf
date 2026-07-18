variable "project_name" {
  type    = string
  default = "keypkey"
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for the DB subnet group (from the vpc module)"
  type        = list(string)
}

variable "rds_sg_id" {
  description = "Security group ID that allows inbound MySQL only from EC2 (from the security-groups module)"
  type        = string
}

variable "instance_class" {
  description = "RDS instance size"
  type        = string
  default     = "db.t3.micro"
}

variable "engine_version" {
  description = "MySQL engine version"
  type        = string
  default     = "8.0"
}

variable "allocated_storage" {
  description = "Storage size in GB"
  type        = number
  default     = 20
}

variable "db_name" {
  description = "Initial database name"
  type        = string
  default     = "keypkey"
}

variable "db_username" {
  description = "Master username for the database"
  type        = string
  default     = "keypkey_admin"
}

variable "db_password" {
  description = "Master password for the database. Pass this via a .tfvars file that is NOT committed to git, or via TF_VAR_db_password env var."
  type        = string
  sensitive   = true
}
