module "vpc" {
  source = "../../modules/vpc"

  project_name = var.project_name
}

module "security_groups" {
  source = "../../modules/security-groups"

  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
}

module "rds" {
  source = "../../modules/rds"

  project_name       = var.project_name
  private_subnet_ids = module.vpc.private_subnet_ids
  rds_sg_id          = module.security_groups.rds_sg_id
  db_password        = var.db_password
}

module "iam" {
  source = "../../modules/iam"

  project_name = var.project_name
}

module "alb" {
  source = "../../modules/alb"

  project_name      = var.project_name
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  alb_sg_id         = module.security_groups.alb_sg_id
}

module "compute" {
  source = "../../modules/compute"

  project_name          = var.project_name
  ec2_sg_id             = module.security_groups.ec2_sg_id
  private_subnet_ids    = module.vpc.private_subnet_ids
  instance_profile_name = module.iam.instance_profile_name
  target_group_arn      = module.alb.target_group_arn

  db_host     = module.rds.db_address
  db_name     = "keypkey"
  db_user     = "keypkey_admin"
  db_password = var.db_password
  jwt_secret  = var.jwt_secret
  vault_secret  = var.vault_secret

  github_repo_url = var.github_repo_url
}
