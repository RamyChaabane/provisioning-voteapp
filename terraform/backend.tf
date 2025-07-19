terraform {
  backend "remote" {
    organization = "ramy-learning"

    workspaces {
      name = "vote-app"
    }
  }
}
