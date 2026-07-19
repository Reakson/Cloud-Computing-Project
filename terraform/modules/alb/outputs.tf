output "alb_dns_name" {
  description = "Public DNS name of the ALB — this is your app's public URL"
  value       = aws_lb.main.dns_name
}

output "target_group_arn" {
  description = "ARN of the target group — the ASG needs this to register instances"
  value       = aws_lb_target_group.app.arn
}
