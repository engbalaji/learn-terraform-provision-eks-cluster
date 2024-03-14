resource "helm_release" "argocd" {
  name       = "argocd-poc"
  chart      = "argo-cd"
  version    = "5.27.3"
  repository = "https://argoproj.github.io/argo-helm"
  namespace  = "argocd-poc"
  timeout    = 1200
  values     = [templatefile("./argocd/install.yaml", {})]
  # Set any desired values or leave them as default
}

resource "null_resource" "password" {
  provisioner "local-exec" {
    working_dir = "./argocd"
    command     = "kubectl -n argocd-staging get secret argocd-initial-admin-secret -o jsonpath={.data.password} | base64 -d > argocd-login.txt"
  }
}   

resource "null_resource" "del-argo-pass" {
  depends_on = [null_resource.password]
  provisioner "local-exec" {
    command = "kubectl -n argocd-staging delete secret argocd-initial-admin-secret"
  }
}
