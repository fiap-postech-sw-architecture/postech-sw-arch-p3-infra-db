# Variaveis da infraestrutura do banco (fase 3).
#
# Valores locais vao em terraform.tfvars (fora do git — ver .gitignore e
# terraform.tfvars.example); no CD, via TF_VAR_* nos secrets do Actions.

variable "aws_profile" {
  description = "Profile AWS local com as credenciais do Learner Lab"
  type        = string
  default     = "academy"
}

variable "db_name" {
  description = "Nome do database inicial criado pelo RDS"
  type        = string
  default     = "pytstop"
}

variable "db_username" {
  description = "Usuario master do banco"
  type        = string
  default     = "pytstop"
}

variable "db_password" {
  description = "Senha do usuario master (sem Secrets Manager — IAM/KMS restritos no Academy; ver rds.tf)"
  type        = string
  sensitive   = true
}

variable "instance_class" {
  description = "Classe da instancia RDS (ADR-026: menor classe que roda Postgres 16)"
  type        = string
  default     = "db.t3.micro"
}

variable "allowed_cidr_blocks" {
  description = "CIDRs com acesso ao 5432; vazio = CIDR da default VPC (cobre EKS e lambda na mesma VPC)"
  type        = list(string)
  default     = []
}

variable "extra_security_group_ids" {
  description = "SGs adicionais com acesso ao 5432 (ex.: SG dos nodes do EKS, criado pelo repo principal)"
  type        = list(string)
  default     = []
}

variable "publicly_accessible" {
  description = "Expor endpoint publico (so para debug pontual na demo; manter false)"
  type        = bool
  default     = false
}
