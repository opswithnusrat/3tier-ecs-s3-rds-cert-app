output "rds_endpoint" {
  description = "The RDS endpoint"
  value       = aws_db_instance.my-db.endpoint
}

output "rds_instance_identifier" {
  description = "The RDS instance identifier"
  value       = aws_db_instance.my-db.id
}

output "rds_db_name" {
  description = "The name of the RDS database"
  value       = aws_db_instance.my-db.db_name
}

output "rds_username" {
  description = "The master username for the RDS instance"
  value       = aws_db_instance.my-db.username
}

output "db_instance_id" {
  description = "DB indentifire"
    value = aws_db_instance.my-db.identifier
}
