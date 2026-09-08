# Provider AWS da infraestrutura do banco gerenciado (fase 3; ADR-026/031).
#
# Conta AWS Academy Learner Lab: credenciais temporarias rotativas obtidas
# a cada "Start Lab" e gravadas na cadeia padrao, na regiao us-east-1.

terraform {
  required_version = ">= 1.10"

  backend "s3" {
    bucket       = "pytstop-terraform-state-924563550535"
    key          = "rds/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"

  # Tags aplicadas a todos os recursos: facilita achar (e destruir) tudo
  # que a fase 3 criou dentro da conta compartilhada do Academy.
  default_tags {
    tags = {
      projeto = "pytstop"
      fase    = "3"
    }
  }
}
