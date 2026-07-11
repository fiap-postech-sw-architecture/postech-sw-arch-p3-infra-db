# Saidas consumidas pelo repo principal (DATABASE_URL do app no EKS e da
# lambda). A URL sai SEM a senha de proposito: a senha nao deve transitar
# por output/log — o consumidor injeta ${DB_PASSWORD} no placeholder.

output "endpoint" {
  description = "Endpoint do RDS (host:porta)"
  value       = aws_db_instance.pytstop.endpoint
}

output "port" {
  description = "Porta do PostgreSQL"
  value       = aws_db_instance.pytstop.port
}

output "database_url" {
  description = "DATABASE_URL sem a senha — substituir :SENHA@ pelo valor real na injecao"
  value       = "postgresql://${aws_db_instance.pytstop.username}:SENHA@${aws_db_instance.pytstop.endpoint}/${aws_db_instance.pytstop.db_name}"
}
