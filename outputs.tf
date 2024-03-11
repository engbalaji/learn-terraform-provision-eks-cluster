# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = "eks.cluster_endpoint"
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane"
  value       = "aws_security_group"
}

output "region" {
  description = "AWS region"
  value       = var.region
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = "eks.cluster_name"
}
