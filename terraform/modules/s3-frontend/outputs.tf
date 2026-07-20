output "bucket_name" {
  description = "Upload the built frontend here with `aws s3 sync`"
  value       = aws_s3_bucket.frontend.id
}

output "frontend_url" {
  description = "Public S3 static website URL"
  value       = "http://${aws_s3_bucket_website_configuration.frontend.website_endpoint}"
}