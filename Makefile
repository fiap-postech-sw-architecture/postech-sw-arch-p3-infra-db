# Alvos da infraestrutura do banco (fase 3).
#
# gate roda offline (sem credenciais): fmt + validate com init -backend=false.
# plan/apply/destroy requerem credenciais do Learner Lab na cadeia padrao.

.PHONY: fmt fmt-check validate gate plan apply destroy

fmt:
	terraform fmt -recursive

fmt-check:
	terraform fmt -check -recursive

validate:
	terraform init -backend=false -input=false
	terraform validate

gate: fmt-check validate

# Requer credenciais: Start Lab e atualize a cadeia padrao antes.
plan:
	terraform init -input=false
	terraform plan

# Requer credenciais (idem plan).
apply:
	terraform init -input=false
	terraform apply

# Requer credenciais. Obrigatorio pos-demo (budget do Academy).
destroy:
	terraform init -input=false
	terraform destroy
