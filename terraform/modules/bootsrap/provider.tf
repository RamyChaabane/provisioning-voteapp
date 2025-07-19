terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.16.1"
    }
    scaleway = {
      source  = "scaleway/scaleway"
      version = "2.48.0"
    }
  }
}

provider "helm" {
  kubernetes {
    host                   = var.kube_host
    token                  = var.kube_token
    cluster_ca_certificate = var.base64_cluster_ca_certificate
  }
}

provider "kubernetes" {
  host                   = var.kube_host
  token                  = var.kube_token
  cluster_ca_certificate = var.base64_cluster_ca_certificate
}

provider "scaleway" {
  access_key = var.default_access_key
  secret_key = var.default_secret_key
  project_id = var.default_project_id
  region     = var.region
  zone       = var.zone
}
