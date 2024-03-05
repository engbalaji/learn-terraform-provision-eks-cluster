# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

provider "aws" {
  region = var.region
}

# Filter out local zones, which are not currently supported 
# with managed node groups

data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

locals {
  cluster_name = "petest1-eks-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.15.3"

  cluster_name    = local.cluster_name
  cluster_version = "1.27"

  vpc_id                  = "vpc-b30658d4"
  #endpoint_private_access = true
  #endpoint_public_access  = false
  cluster_ip_family       = "ipv4"
  cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]


  # EKS Managed Node Group(s)
  # https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/docs/managed_node_groups.md

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"
    ami_release_version = "1.27.0"
    disk_size = 30 # in GB
    vpc_security_group_ids = ["sg-02cd5c886d8b07682"]
    subnets = ["subnet-89eb03a4", "subnet-b64d14ff"]
    instance_types = ["t3.small"]
    capacity_type  = "ON_DEMAND"
    force_update_version = true

  }

  eks_managed_node_groups = {
    one = {
      name = "petest1-node-group-1"
      instance_types = ["t3.small"]
      
      min_size     = 1
      max_size     = 3
      desired_size = 2
    }

    two = {
      name = "petest1-node-group-2"
      instance_types = ["t3.small"]

      min_size     = 1
      max_size     = 2
      desired_size = 1
    }
  }
}


# https://aws.amazon.com/blogs/containers/amazon-ebs-csi-driver-is-now-generally-available-in-amazon-eks-add-ons/ 
data "aws_iam_policy" "ebs_csi_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

module "irsa-ebs-csi" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "4.7.0"

  create_role                   = true
  role_name                     = "AmazonEKSTFEBSCSIRole-${module.eks.cluster_name}"
  provider_url                  = module.eks.oidc_provider
  role_policy_arns              = [data.aws_iam_policy.ebs_csi_policy.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
}

resource "aws_eks_addon" "ebs-csi" {
  cluster_name             = module.eks.cluster_name
  addon_name               = "aws-ebs-csi-driver"
  addon_version            = "v1.20.0-eksbuild.1"
  service_account_role_arn = module.irsa-ebs-csi.iam_role_arn
  tags = {
    "eks_addon" = "ebs-csi"
    "terraform" = "true"
  }
}