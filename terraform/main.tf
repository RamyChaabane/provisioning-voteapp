module "cluster" {
  source = "./modules/cluster"

  access_key = var.access_key
  secret_key = var.secret_key
  project_id = var.project_id
}

module "bootstrap" {
  source = "./modules/bootsrap"

  kube_host                     = module.cluster.kube_host
  kube_token                    = module.cluster.kube_token
  base64_cluster_ca_certificate = base64decode(module.cluster.cluster_ca_certificate)

  default_access_key = var.default_access_key
  default_secret_key = var.default_secret_key
  default_project_id = var.default_project_id
}

locals {
  argocd_repo_url = "https://github.com/RamyChaabane/argocd-voteapp"
}

module "vote-app-dev" {
  source = "./modules/argocd"

  destination_namespace = "vote-dev"
  name                  = "vote-app-dev"
  path                  = "k8s/overlays/dev"
  repo_url              = local.argocd_repo_url
  argocd_server_addr    = module.bootstrap.argocd_server_addr
  argocd_admin_password = module.bootstrap.argocd_admin_password
}

module "vote-app-stg" {
  source = "./modules/argocd"

  destination_namespace = "vote-stg"
  name                  = "vote-app-stg"
  path                  = "k8s/overlays/stg"
  repo_url              = local.argocd_repo_url
  argocd_server_addr    = module.bootstrap.argocd_server_addr
  argocd_admin_password = module.bootstrap.argocd_admin_password
}

module "vote-app-prd" {
  source = "./modules/argocd"

  destination_namespace = "vote-prd"
  name                  = "vote-app-prd"
  path                  = "k8s/overlays/prd"
  repo_url              = local.argocd_repo_url
  argocd_server_addr    = module.bootstrap.argocd_server_addr
  argocd_admin_password = module.bootstrap.argocd_admin_password
}

module "monitoring" {
  source = "./modules/argocd"

  destination_namespace = "monitoring"
  name                  = "monitoring-stack"
  path                  = "monitoring"
  repo_url              = local.argocd_repo_url
  argocd_server_addr    = module.bootstrap.argocd_server_addr
  argocd_admin_password = module.bootstrap.argocd_admin_password
}
