
variable "db_instance_class" {
  description = "RDS instance type"
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "Database name"
  default     = "log"
}

variable "db_username" {
  description = "username for PostgreSQL"
  type        = string
  default     = "postgres"
}

variable "db_password" {
  description = "password for PostgreSQL"
  default     = "test12#!"
}

variable "db_storage" {
  description = "Storage size in GB"
  default     = 15
}

variable "tf_state_bucket" {
  description = "Name of the s3 bucket in AWS for storing state"
  default     = "my-terraform-tfstate12"

}

variable "tf_state_lock_table" {
  description = "Name of DynamoDb table for state locking"
  default     = "express-postgres-api-tf-lock"

}

variable "project" {
  description = "Project name for tagging resources"
  default     = "recipi-app-api"

}

variable "contact" {
  description = "contact for tagging resources"
  default     = "fitsum@example.com"

}
