# Groups the private subnets so RDS knows which subnets it's allowed to
# place its instance(s) in. AWS requires at least 2 subnets in 2 different
# AZs for a DB subnet group, even for a single-AZ instance.
resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}

resource "aws_db_instance" "main" {
  identifier     = "${var.project_name}-db"
  engine         = "mysql"
  engine_version = var.engine_version
  instance_class = var.instance_class

  allocated_storage     = var.allocated_storage
  storage_type          = "gp3"
  db_name               = var.db_name
  username              = var.db_username
  password              = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.rds_sg_id]

  # Single-AZ keeps this free-tier friendly for a course project.
  # Set to true for a real production deployment (adds a standby replica,
  # roughly doubles the RDS cost).
  multi_az = false

  publicly_accessible = false

  # Course project: skip final snapshot so `terraform destroy` doesn't
  # get stuck waiting on a snapshot you don't need. Don't do this for
  # anything with real user data you care about.
  skip_final_snapshot = true

  backup_retention_period = 1

  tags = {
    Name = "${var.project_name}-db"
  }
}
