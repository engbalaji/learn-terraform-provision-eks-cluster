# main.tf

resource "helm_release" "argocd" {
  name            = "argocd"
  repository      = "https://argoproj.github.io/argo-helm"
  chart           = "argo-cd"
  namespace       = "argocd"
  create_namespace = true
  version         = "3.35.4"
  values          = [file("argocd.yaml")]
}

# provider.tf
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

# values.yaml
global:
  image:
    tag: "v2.6.6"
  dex:
    enabled: false
  server:
    extraArgs:
      - --insecure


  set_sensitive {
    name  = "configs.secret.argocdServerAdminPassword"
    value = var.admin_password == "" ? "" : bcrypt(var.admin_password)
  }

  set {
    name  = "configs.params.server\\.insecure"
    value = var.insecure == false ? false : true
  }

  set {
    name  = "dex.enabled"
    value = var.enable_dex == true ? true : false
  }
}