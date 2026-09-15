variable "aws_region" {
  type        = string
  description = "Região da AWS"
}

variable "sql_db_name" {
  type        = string
  description = "Nome do banco de dados SQL Server"
}

variable "sql_db_user" {
  type        = string
  description = "Usuário padrão do banco"
}

variable "sql_db_password" {
  type        = string
  sensitive   = true
  description = "Senha padrão do banco"
}

variable "cluster_name" {
  type        = string
  description = "Nome do cluster EKS"
}