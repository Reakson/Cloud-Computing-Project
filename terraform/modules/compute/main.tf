# Automatically fetch the latest Amazon Linux 2023 AMI for the current region
# No hardcoded AMI IDs — always gets the right one
data "aws_ssm_parameter" "al2023_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

locals {
  user_data = <<-SCRIPT
#!/bin/bash
exec > /var/log/keypkey-startup.log 2>&1
set -e

echo "=== KeypKey startup: $(date) ==="

echo "=== System update ==="
dnf update -y

echo "=== Install git ==="
dnf install -y git

echo "=== Install Node.js 20 ==="
dnf install -y nodejs npm
echo "Node: $(node --version), NPM: $(npm --version)"

echo "=== Install PM2 ==="
npm install -g pm2

echo "=== Clone repo ==="
cd /home/ec2-user
git clone ${var.github_repo_url} app
chown -R ec2-user:ec2-user /home/ec2-user/app

echo "=== Write .env ==="
cd /home/ec2-user/app/backend
cat > .env << 'ENVEOF'
PORT=3000
DB_HOST=${var.db_host}
DB_PORT=3306
DB_NAME=${var.db_name}
DB_USER=${var.db_user}
DB_PASSWORD=${var.db_password}
JWT_SECRET=${var.jwt_secret}
VAULT_SECRET=${var.vault_secret}
FRONTEND_URL=${var.frontend_url}
NODE_ENV=production
ENVEOF
chown ec2-user:ec2-user .env

echo "=== npm install ==="
sudo -u ec2-user npm install --production

echo "=== Start app with PM2 ==="
sudo -u ec2-user pm2 start server.js --name keypkey-api
sudo -u ec2-user pm2 save
env PATH=$PATH:/usr/bin pm2 startup systemd -u ec2-user --hp /home/ec2-user
systemctl enable pm2-ec2-user || true

echo "=== Done: $(date) ==="
SCRIPT
}

resource "aws_launch_template" "app" {
  name_prefix   = "${var.project_name}-lt-"
  image_id      = data.aws_ssm_parameter.al2023_ami.value
  instance_type = var.instance_type

  iam_instance_profile {
    name = var.instance_profile_name
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [var.ec2_sg_id]
  }

  user_data = base64encode(local.user_data)

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.project_name}-app-server"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "app" {
  name                      = "${var.project_name}-asg"
  min_size                  = var.asg_min_size
  max_size                  = var.asg_max_size
  desired_capacity          = var.asg_desired_capacity
  vpc_zone_identifier       = var.private_subnet_ids
  target_group_arns         = [var.target_group_arn]
  health_check_type         = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-app-server"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "scale_out" {
  name                   = "${var.project_name}-scale-out"
  autoscaling_group_name = aws_autoscaling_group.app.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 120
}

resource "aws_autoscaling_policy" "scale_in" {
  name                   = "${var.project_name}-scale-in"
  autoscaling_group_name = aws_autoscaling_group.app.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 120
}
