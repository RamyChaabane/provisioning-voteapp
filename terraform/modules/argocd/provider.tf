terraform {
  required_providers {
    argocd = {
      source  = "argoproj-labs/argocd"
      version = "7.2.0"
    }
  }
}

provider "argocd" {
  server_addr = var.argocd_server_addr
  username    = "admin"
  password    = var.argocd_admin_password
  insecure    = true
}
