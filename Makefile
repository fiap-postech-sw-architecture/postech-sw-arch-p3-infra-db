# Alvos da infraestrutura do banco (fase 3).
#
# gate roda offline (sem credenciais): fmt + validate com init -backend=false.
# plan/apply/destroy requerem credenciais do Learner Lab ativas no profile
# "academy" (Start Lab -> AWS Details -> ~/.aws/credentials).

.PHONY: fmt fmt-check validate gate plan apply destroy

fmt:
	terraform fmt -recursive

fmt-check:
	terraform fmt -check -recursive

validate:
	terraform init -backend=false -input=false
	terraform validate

gate: fmt-check validate

# Requer credenciais: Start Lab e atualize o profile academy antes.
plan:
	AWS_PROFILE=academy terraform init -input=false
	AWS_PROFILE=academy terraform plan

# Requer credenciais (idem plan).
apply:
	AWS_PROFILE=academy terraform init -input=false
	AWS_PROFILE=academy terraform apply

# Requer credenciais. Obrigatorio pos-demo (budget do Academy).
destroy:
	AWS_PROFILE=academy terraform destroy
