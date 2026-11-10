output "address" {
  value = aws_db_instance.db_instance
}

output "port" {
  value = aws_db_instance.db_instance
}

output "db_name" {
  value = aws_db_instance.db_instance
}

output "secret_arn" {
  description = "Secrets Manager ARN of the master credentials (JSON: username, password)"
  value       = aws_db_instance.db_instance.arn
}

output "sg_id" {
  value = aws_security_group.db.id
}