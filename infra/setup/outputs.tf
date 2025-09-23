output "rds_endpoint" {
  description = "postgress endpoint"
  value       = aws_db_instance.db_instance.endpoint
}

# EC2 public IP (for SSH or API testing)
output "ec2_public_ip" {
  value       = aws_instance.my_api_server.public_ip
  description = "The public IP address of the EC2 API server"
}

output "rds_db_name" {
  value = aws_db_instance.db_instance.db_name
}
