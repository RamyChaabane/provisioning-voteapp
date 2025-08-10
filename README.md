# 🏗️ provisioning-voteapp

Infrastructure-as-Code for **VoteApp** — provisions the Kubernetes cluster(s) and bootstraps the GitOps platform used to deploy the application.

> This repository contains the Terraform configuration and CI automation used to provision cluster, networking, and bootstrap Argo CD so the `argocd-voteapp` repository can manage application delivery.

---

## 🔎 What this repo is / why it exists

`provisioning-voteapp` is the *infrastructure* foundation for VoteApp. Its primary responsibilities are:

- Provision a Kubernetes cluster and supporting cloud resources
- Create environment-specific namespaces (`dev`, `stg`, `prd`)
- Bootstrap Argo CD and wire it to the application deployment repo (`argocd-voteapp`)
- Provide kubeconfig and access to CI/CD systems (optionally storing kubeconfig in a secret manager)
- Run Terraform validation & automation through GitHub Actions

---

## 🛠️ Tools & Technologies
- Terraform – Infrastructure as Code (IaC) to provision cloud and Kubernetes resources. 
- Terraform Cloud – Used for:
  - Remote state storage 
  - State locking 
  - Collaborative runs 

- Kubernetes – Cluster for running application workloads. 
- Helm – For deploying certain components (optional depending on modules used). 
- GitHub Actions – CI/CD automation for Terraform runs.

---
## 📂 Repo layout (high level)
```
.
├── .github/
│ └── workflows/ # CI: terraform fmt/validate/plan/apply workflows
├── terraform/ # Terraform configuration (modules, environment stacks)
│ └── ...
├── .gitignore
└── README.md
```

Terraform code lives under `terraform/` (module structure + environment configs). The repo has GitHub Actions workflows under `.github/workflows/`.

---
## 🔁 Typical GitOps bootstrapping flow

1. Run terraform apply to create the cluster and network. 
2. Terraform bootstraps Argo CD. 
3. Argo CD is configured to watch the argocd-voteapp repository and sync manifests to the cluster. 
4. Application images pushed by vote-app CI are promoted using Renovate PRs in the argocd-voteapp repo; Argo CD then reconciles the cluster state.

This separation keeps infrastructure provisioning (this repo) independent from application delivery (argocd-voteapp) and application code (vote-app).

---
## 📈 Observability & Monitoring (bootstrapped separately)
This repo provisions the cluster and usually bootstraps the observability stack via GitOps (Argo CD) — e.g., Prometheus, Grafana — by ensuring the monitoring namespace and RBAC exist. The actual monitoring manifests can be kept in the argocd-voteapp repo under monitoring/ so Argo CD can deploy/upgrade them.

---
## ✅ CI practices and safety
- Format & lint: terraform fmt -recursive runs in CI. 
- Validate & plan: terraform validate and terraform plan run in PRs. 
- Plan approvals: terraform apply only runs automatically on main (or through manual approval) — adjust per your org policy. 
- State locking: use remote backend with locking to prevent concurrent applies.

(There are GitHub Actions workflows in this repo for validation and plan/apply automation.)

---
## 🔐 State Management with Terraform Cloud
This repository uses Terraform Cloud for remote state storage and locking, which provides:
- Centralized State Storage – No local state files to lose or corrupt. 
- Concurrency Control – Prevents multiple people from making conflicting changes. 
- Version History – Tracks all state changes over time.
- Secure Storage – Protects sensitive outputs from leaking.

---
## 📜 Example Workflow
```bash
# Initialize Terraform with remote backend in Terraform Cloud
terraform init

# Review the plan
terraform plan

# Apply infrastructure changes
terraform apply
```
---
## 🚩 Troubleshooting pointers
- If Argo CD reports CRDs missing during manifest apply, ensure CRDs are created first (apply CRDs or deploy Helm chart that includes them prior to resources relying on them). 
- For provider-specific auth errors, verify environment variables/TF_VAR_* are set in the workflow runner.

---
## 📌 Why This Project Stands Out
This repository demonstrates:
- IaC discipline: modular Terraform, formatting/linting, remote state recommendations 
- Platform mindset: bootstrapping GitOps (Argo CD) to enable self-service application delivery 
- Security-first approach: recommended use of secret managers and least-privilege service accounts 
- Automated validation: GitHub Actions for fmt, validate, plan and gated apply

These are the behaviours and practices expected of platform/SRE engineering at scale.

---
## 🔗 Related Repositories
- [vote-app](https://github.com/RamyChaabane/VoteApp) - Source code and CI/CD pipeline
- [argocd-voteapp](https://github.com/RamyChaabane/argocd-voteapp) – GitOps deployment definitions managed by Argo CD
