variable "argocd_server_addr" {
  description = "argocd server address fqdn"
}

variable "argocd_admin_password" {
  description = "argocd admin password"
}

variable "name" {
  description = "application name"
}

variable "path" {
  description = "path to k8s resources"
}

variable "destination_namespace" {
  description = "app namespace"
}

variable "argo_namespace" {
  description = "argo namespace"
  default     = "argocd"
}

variable "project" {
  description = "argo project"
  default     = "default"
}

variable "repo_url" {
  description = "github repo url"
}
variable "revision" {
  description = "target branch"
  default     = "main"
}

variable "destination_server" {
  description = "url of the target cluster control plane"
  default     = "https://kubernetes.default.svc"
}

