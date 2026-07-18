variable "project_name" {
  description = "Name prefix used on all resources, e.g. keypkey"
  type        = string
  default     = "keypkey"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "Availability zones to spread subnets across"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets (one per AZ, same order as var.azs)"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets (one per AZ, same order as var.azs)"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}
