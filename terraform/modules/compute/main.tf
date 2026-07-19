locals {
  user_data = <<-EOF
    #!/bin/bash
    set -e

    # --- System update and Node.js install ---
    dnf update -y
    dnf install -y git

    # Install Node.js 20 via NodeSource
    curl -fsSL https://rpm.nodesource.com/setup_20.x | bash -
    dnf install -y nodejs

    # Install PM2 globally — keeps the app running and restarts it on crash/reboot
    npm install -g pm2

    # --- Pull your app code ---
    cd /home/ec2-user
    git clone ${var.github_repo_url} app
    cd app/keypkey-backend

    # Install dependencies
    npm install --production

    # --- Write the .env file the backend reads ---
    cat > .env << 'ENVEOF'
    PORT=3000
    DB_HOST=${var.db_host}
    DB_PORT=3306
    DB_NAME=${var.db_name}
    DB_USER=${var.db_user}
    DB_PASSWORD=${var.db_password}
    JWT_SECRET=${var.jwt_secret}
    FRONTEND_URL=${var.frontend_url}
    NODE_ENV=production
    ENVEOF

    # --- Start the app with PM2 ---
    pm2 start server.js --name keypkey-api
    pm2 startup systemd -u ec2-user --hp /home/ec2-user
    pm2 save

    # --- CloudWatch agent install (sends logs to CloudWatch) ---
    dnf install -y amazon-cloudwatch-agent
    /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
      -a fetch-config -m ec2 -s -c default
  EOF
}

resource "aws_launch_template" "app" {
  name_prefix   = "${var.project_name}-lt-"
  image_id      = var.ami_id
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
  name                = "${var.project_name}-asg"
  min_size            = var.asg_min_size
  max_size            = var.asg_max_size
  desired_capacity    = var.asg_desired_capacity
  vpc_zone_identifier = var.private_subnet_ids
  target_group_arns   = [var.target_group_arn]
  health_check_type   = "ELB"

  # Wait for the ALB health check to confirm instances are healthy
  # before marking the ASG update as complete
  health_check_grace_period = 180

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

# Scale out when CPU > 70% for 2 consecutive periods
resource "aws_autoscaling_policy" "scale_out" {
  name                   = "${var.project_name}-scale-out"
  autoscaling_group_name = aws_autoscaling_group.app.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 120
}

# Scale in when CPU < 30%
resource "aws_autoscaling_policy" "scale_in" {
  name                   = "${var.project_name}-scale-in"
  autoscaling_group_name = aws_autoscaling_group.app.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 120
}
