# output.tf

# Output the EKS cluster name
output "eks_cluster_name" {
  value = aws_eks_cluster.my_cluster.name
}

# Output the EKS cluster endpoint URL
output "eks_cluster_endpoint" {
  value = aws_eks_cluster.my_cluster.endpoint
}

# Output the EKS cluster security group IDs
output "eks_cluster_security_groups" {
  value = aws_eks_cluster.my_cluster.vpc_config[0].security_group_ids
}

# Output the EKS cluster worker node IAM role ARN
output "eks_node_role_arn" {
  value = aws_eks_cluster.my_cluster.node_groups[0].node_group_arn
}

# Additional outputs can be added as needed
# For example, you can output the kubeconfig for kubectl access
output "kubeconfig" {
  value = aws_eks_cluster.my_cluster.kubeconfig
}