variable "kube_host" {
  description = "hostname of kube api"
}

variable "kube_token" {
  description = "token to authenticate against kube api"
}

variable "base64_cluster_ca_certificate" {
  description = "cluster ca certificate in base64 format"
}

variable "default_access_key" {
  description = "default api access key"
}

variable "default_secret_key" {
  description = "default api secret key"
}

variable "default_project_id" {
  description = "default scw project id"
}

variable "region" {
  default = "fr-par"
}

variable "zone" {
  default = "fr-par-1"
}
