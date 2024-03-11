# eks-cluster.tf

#Provider information
provider "aws" {
  region = var.region
}

# Data sources for existing VPC, subnets, and security groups
data "aws_vpc" "existing_vpc" {
  id = "vpc-b30658d4"
}

#data "aws_subnet_ids" "existing_subnets" {
#  vpc_id = data.aws_vpc.existing_vpc.id
#  tags   = { Name = "your-subnet-tag" }
#  #subnet_ids = ["subnet-89eb03a4", "subnet-c496e7e9", "subnet-b64d14ff" ]
#}

data "aws_security_group" "existing_sg" {
  name = "test_bm_sg_app"
}

# Create EKS cluster
resource "aws_eks_cluster" "my_cluster" {
  name     = "PEPOC-EKS-Cluster"
  role_arn = "arn:aws:iam::960456129040:role/AWS_EKS_Admin"

  vpc_config {
    #subnet_ids = data.aws_subnet_ids.existing_subnets.ids
    security_group_ids = [data.aws_security_group.existing_sg.id]
    subnet_ids = ["subnet-89eb03a4", "subnet-c496e7e9", "subnet-b64d14ff" ]
  }
}

#create node group 1
resource "aws_eks_node_group" "example_nodes" {
  cluster_name    = "PEPOC-EKS-Cluster"
  node_group_name = "pe-nodegrp-1"
  node_role_arn   = "arn:aws:iam::960456129040:role/bmeks1-NodeInstanceRole-1AM6MX3S587QX"
  subnet_ids = ["subnet-89eb03a4", "subnet-c496e7e9", "subnet-b64d14ff" ] 
  instance_type = "t2.medium"
  min_size       = 1
  max_size       = 2
}
