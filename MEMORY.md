# Project Memory -- postech-sw-arch-p3-infra-db

<!-- last-consolidated: 2026-07-11 -->

Add-only log of project-specific learnings. New entries go to the top of each section. Never edit historical entries -- add a contradicting entry above instead.

Updated by AI agents at task end per `postech-ai-helper/ai/canonical/task-end-review.md`. The `last-consolidated` marker above is updated only when `/consolidate-memory` runs, not on every append.

## Recent decisions

- 2026-09-07 - Primeiro deploy automatico de producao concluido no run 34177626665; RDS PostgreSQL 16.13 permaneceu `available`, privado e convergiu pelo state remoto S3 sem recriacao
- 2026-09-06 - State remoto substitui a decisao inicial de state local: backend S3 `pytstop-terraform-state-924563550535` na chave `rds/terraform.tfstate`, versionamento no bucket e lock nativo (`use_lockfile`, Terraform >=1.10); execucao local e Actions compartilham o mesmo state sem DynamoDB
- 2026-07-11 - Bootstrap fase 3: repo dedicado do banco gerenciado (RDS PostgreSQL 16, db.t3.micro single-AZ na default VPC) - restricoes do AWS Academy: sem IAM novo, sem Secrets Manager (senha via variavel sensitive), state local sem backend remoto - ADR-026/031 no repo principal

## Discovered conventions

## Gotchas

## Tech debt / TODO

## Review lessons
