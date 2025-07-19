output "kube_host" {
  value     = scaleway_k8s_cluster.vote.kubeconfig[0].host
  sensitive = true
}

output "kube_token" {
  value     = scaleway_k8s_cluster.vote.kubeconfig[0].token
  sensitive = true
}

output "cluster_ca_certificate" {
  value     = scaleway_k8s_cluster.vote.kubeconfig[0].cluster_ca_certificate
  sensitive = true
}
