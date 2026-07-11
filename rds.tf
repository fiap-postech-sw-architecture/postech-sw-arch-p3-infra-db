# RDS for PostgreSQL 16 (ADR-031): instancia gerenciada minima para a demo
# da fase 3, dentro das restricoes do AWS Academy Learner Lab — proibido
# criar IAM (so data sources), budget pequeno (db.t3.micro single-AZ,
# destroy pos-demo), regiao us-east-1.
#
# Rede: reusa a default VPC da conta em vez de criar VPC propria — menos
# recursos para o budget do lab e zero configuracao de rota/NAT. O cluster
# EKS do repo principal vive na mesma default VPC, entao a liberacao do
# 5432 por CIDR da VPC ja cobre os pods.

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Subnet group sobre todas as subnets da default VPC: o RDS exige >= 2 AZs
# no grupo mesmo em single-AZ (ele escolhe uma para a instancia).
resource "aws_db_subnet_group" "pytstop" {
  name       = "pytstop-db"
  subnet_ids = data.aws_subnets.default.ids
}

# Security group do banco: 5432 liberado a partir dos CIDRs da variavel
# (default: CIDR da propria default VPC — cobre app no EKS e lambda que
# rodam nela). Para liberar um SG especifico (ex.: node group do EKS) em
# vez de CIDR, adicione-o em var.extra_security_group_ids.
resource "aws_security_group" "db" {
  name        = "pytstop-db"
  description = "Acesso PostgreSQL ao RDS do PytStop"
  vpc_id      = data.aws_vpc.default.id

  # Sem egress: SG e stateful (respostas passam) e o RDS nao origina trafego.
}

resource "aws_vpc_security_group_ingress_rule" "postgres_cidr" {
  for_each = toset(coalescelist(var.allowed_cidr_blocks, [data.aws_vpc.default.cidr_block]))

  security_group_id = aws_security_group.db.id
  description       = "PostgreSQL a partir de CIDR permitido"
  from_port         = 5432
  to_port           = 5432
  ip_protocol       = "tcp"
  cidr_ipv4         = each.value
}

resource "aws_vpc_security_group_ingress_rule" "postgres_sg" {
  for_each = toset(var.extra_security_group_ids)

  security_group_id            = aws_security_group.db.id
  description                  = "PostgreSQL a partir de SG permitido (ex.: nodes do EKS)"
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
  referenced_security_group_id = each.value
}

# Instancia minima de demo (ADR-026): single-AZ, 20GB gp3, sem snapshot
# final nem deletion protection — o banco e efemero por definicao no
# Academy (a conta expira e o destroy pos-demo e obrigatorio pelo budget).
#
# Credenciais via variaveis sensitive em vez de Secrets Manager: criar
# secrets + policy de leitura exigiria IAM/KMS, restritos no Learner Lab.
# Trade-off aceito: a senha vive no tfvars local (fora do git) e no state
# local (tambem fora do git); no CD, em secret do GitHub Actions.
resource "aws_db_instance" "pytstop" {
  identifier = "pytstop"

  engine         = "postgres"
  engine_version = "16"
  instance_class = var.instance_class

  allocated_storage = 20
  storage_type      = "gp3"
  multi_az          = false

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.pytstop.name
  vpc_security_group_ids = [aws_security_group.db.id]
  publicly_accessible    = false # fixo: RFC-003 proibe exposicao publica do banco

  skip_final_snapshot = true  # lab efemero: nada a preservar no destroy
  deletion_protection = false # idem: destroy pos-demo sem fricao
}
