resource "argocd_application" "vote_app" {
  metadata {
    name      = var.name
    namespace = var.argo_namespace
  }

  spec {
    project = var.project

    source {
      repo_url        = var.repo_url
      target_revision = var.revision
      path            = var.path
    }

    destination {
      server    = var.destination_server
      namespace = var.destination_namespace
    }

    sync_policy {
      automated {
        prune     = true
        self_heal = true
      }

      sync_options = [
        "CreateNamespace=true"
      ]
    }
  }
}
