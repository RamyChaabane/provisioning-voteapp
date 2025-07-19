resource "helm_release" "nginx_ingress" {
  name       = "ingress-nginx"
  namespace  = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.10.1"

  create_namespace = true

  set {
    name  = "controller.publishService.enabled"
    value = "true"
  }

  set {
    name  = "controller.metrics.enabled"
    value = "true"
  }

  set {
    name  = "controller.admissionWebhooks.enabled"
    value = "true"
  }

  wait = true
}

resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  namespace  = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.18.2"

  create_namespace = true

  set {
    name  = "crds.enabled"
    value = "true"
  }

  set {
    name  = "prometheus.enabled"
    value = "false"
  }

  values = [
    file("./${path.module}/helm/cert-manager/disable-ingress-path-type-values.yaml")
  ]

  wait = true
}

resource "helm_release" "argocd" {
  name       = "argocd"
  namespace  = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "5.51.6"

  create_namespace = true

  wait = true
}

resource "kubernetes_manifest" "argocd_ingress" {
  manifest   = yamldecode(file("${path.module}/manifests/argocd/ingress-argocd.yaml"))
  depends_on = [helm_release.argocd]
}

data "kubernetes_service" "nginx_ingress" {
  metadata {
    name      = "ingress-nginx-controller"
    namespace = "ingress-nginx"
  }

  depends_on = [helm_release.nginx_ingress]
}

resource "scaleway_domain_record" "argo_hostname" {
  dns_zone = "rch.domain-buy-5.com"
  name     = "argocd"
  type     = "A"
  data     = data.kubernetes_service.nginx_ingress.status[0].load_balancer[0].ingress[0].ip
  ttl      = 3600
}

resource "kubernetes_manifest" "cluster_issuer" {
  manifest   = yamldecode(file("${path.module}/manifests/cert-manager/cluster-issuer.yaml"))
  depends_on = [helm_release.cert_manager]
}

data "kubernetes_secret" "argocd_admin_password" {
  metadata {
    name      = "argocd-initial-admin-secret"
    namespace = "argocd"
  }

  depends_on = [helm_release.argocd]
}
