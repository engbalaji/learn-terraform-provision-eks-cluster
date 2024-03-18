provider "helm" {
  kubernetes {
    config_path = "$HOME/.kube/config"
  }
}