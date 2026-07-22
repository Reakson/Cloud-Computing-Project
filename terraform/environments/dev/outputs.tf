output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "alb_sg_id" {
  value = module.security_groups.alb_sg_id
}

output "ec2_sg_id" {
  value = module.security_groups.ec2_sg_id
}

output "rds_sg_id" {
  value = module.security_groups.rds_sg_id
}

output "db_endpoint" {
  value = module.rds.db_endpoint
}

output "db_address" {
  value = module.rds.db_address
}

output "db_port" {
  value = module.rds.db_port
}

output "alb_dns_name" {
  description = "Your app's public URL — open this in a browser after apply"
  value       = module.alb.alb_dns_name
}

output "asg_name" {
  value = module.compute.asg_name
}

output "frontend_url" {
  description = "Open this in a browser to see the deployed frontend"
  value       = module.s3_frontend.frontend_url
}

output "bucket_name" {
  description = "Upload the built frontend here — aws s3 sync dist/ s3://<this>"
  value       = module.s3_frontend.bucket_name
}

#new tra add all, cloudwatch stage 6
output "cloudwatch_dashboard_url" {
  value = module.cloudwatch.dashboard_url
}

output "sns_alarm_topic_arn" {
  value = module.cloudwatch.sns_topic_arn
}
