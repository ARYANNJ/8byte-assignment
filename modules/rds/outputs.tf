output "address" {
  value = aws_db_instance.db_instance.address
}

output "endpoint" {
  value = aws_db_instance.db_instance.endpoint
}

output "port" {
  value = aws_db_instance.db_instance.port
}

output "db_name" {
  value = aws_db_instance.db_instance.db_name
}

output "secret_arn" {
  value = aws_db_instance.db_instance.master_user_secret[0].secret_arn
}

output "sg_id" {
  value = aws_security_group.db.id
}