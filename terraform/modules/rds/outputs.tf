output "db_endpoint" {
  description = "Hostname:port to connect to (use just the hostname part for DB_HOST)"
  value       = aws_db_instance.main.endpoint
}

output "db_address" {
  description = "Hostname only, no port — this is what goes in DB_HOST"
  value       = aws_db_instance.main.address
}

output "db_port" {
  value = aws_db_instance.main.port
}

output "db_name" {
  value = aws_db_instance.main.db_name
}
