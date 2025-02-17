
variable "db_instance_class" {
  description = "RDS instance type"
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "Database name"
  default     = "postgres_db"
}

variable "db_username" {
  description = "username for PostgreSQL"
  default     = "api_user"
}

variable "db_password" {
  description = "password for PostgreSQL"
  default     = "test12#!"
}

variable "db_storage" {
  description = "Storage size in GB"
  default     = 15
}
