# KeypKey — AWS Cloud Deployment

Deploying KeypKey (password manager: Express/MySQL backend, React/Vite frontend)
to AWS using Terraform, for [course name] Cloud Computing project.

## Structure
- `keypkey-backend/` — Express API
- `keypkey-frontend/` — React frontend
- `terraform/` — infrastructure as code
- `docs/` — architecture diagram, cost estimate, challenges/solutions
- `screenshots/` — deployment and auto-scaling evidence

## Deploy
cd terraform/environments/dev
terraform init
terraform plan
terraform apply

## Destroy (when not actively working, to avoid cost)
cd terraform/environments/dev
terraform destroy