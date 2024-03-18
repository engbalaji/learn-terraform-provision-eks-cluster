resource "helm_release" "argocd" {
  name       = "argocd-helm"
  namespace  = "argocd"
 chart      = "argo-cd"
  create_namespace = true
  repository = "https://argoproj.github.io/argo-helm"
  }