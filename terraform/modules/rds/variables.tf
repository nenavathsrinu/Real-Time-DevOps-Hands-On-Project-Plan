variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_user" {
  description = "Database admin username"
  type        = string
}

variable "db_password" {
  description = "Database admin password"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "Instance class for RDS"
  type        = string
}

variable "subnet_ids" {
  description = "Private subnet IDs for RDS subnet group"
  type        = list(string)
}

variable "vpc_security_group_ids" {
  description = "VPC security group IDs for the RDS instance"
  type        = list(string)
}