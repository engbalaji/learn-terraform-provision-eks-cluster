# output.tf

# Output the EKS cluster name
output "eks_cluster_name" {
  value = aws_eks_cluster.my_cluster.name
}

# Output the EKS cluster endpoint URL
output "eks_cluster_endpoint" {
  value = aws_eks_cluster.my_cluster.endpoint
}