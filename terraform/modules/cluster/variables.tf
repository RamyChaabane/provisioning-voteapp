variable "access_key" {
  description = "api access key"
}

variable "secret_key" {
  description = "api secret key"
}

variable "project_id" {
  description = "scw project id"
}

variable "region" {
  default = "fr-par"
}

variable "zone" {
  default = "fr-par-1"
}

variable "cluster_name" {
  default = "vote-app-cluster"
}
