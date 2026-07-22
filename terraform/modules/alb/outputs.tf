output "alb_dns_name" {
  description = "Public DNS name of the ALB — this is your app's public URL"
  value       = aws_lb.main.dns_name
}

output "target_group_arn" {
  description = "ARN of the target group — the ASG needs this to register instances"
  value       = aws_lb_target_group.app.arn
}

#new tra add all, cloudwatch stage 6

output "alb_arn_suffix" {
  value = aws_lb.main.arn_suffix
}

output "target_group_arn_suffix" {
  value = aws_lb_target_group.app.arn_suffix
}
