variable "project_name" {
  description = "Project name"
  type        = string
  default     = "sectest"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus"
}

variable "sql_admin_password" {
  description = "SQL Server admin password"
  type        = string
  default     = "P@ssw0rd123!"  # For testing only
  sensitive   = true
}
