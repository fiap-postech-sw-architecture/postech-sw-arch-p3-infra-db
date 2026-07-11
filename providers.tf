# Provider AWS da infraestrutura do banco gerenciado (fase 3; ADR-026/031).
#
# Conta AWS Academy Learner Lab: credenciais temporarias rotativas obtidas
# a cada "Start Lab" e gravadas no profile local (default "academy"), regiao
# fixa us-east-1 (unica liberada no lab). Sem backend remoto: o state fica
# local e fora do git (.gitignore) — o ciclo de vida do lab e curto e a
# infra e destruida apos a demo, entao um backend S3/DynamoDB seria custo e
# IAM que o Academy nao permite provisionar.

terraform {
  required_version = ">= 1.9"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  profile = var.aws_profile
  region  = "us-east-1"

  # Tags aplicadas a todos os recursos: facilita achar (e destruir) tudo
  # que a fase 3 criou dentro da conta compartilhada do Academy.
  default_tags {
    tags = {
      projeto = "pytstop"
      fase    = "3"
    }
  }
}
