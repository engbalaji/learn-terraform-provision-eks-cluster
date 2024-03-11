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
  capacity_type = "SPOT"
  
  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  launch_template {
    name_prefix = "pe-nodegrp-1"
    
    block_device_mappings {
      device_name = "/dev/xvda"

      ebs {
        volume_size = 20
        volume_type = "gp2"
      }
    }

    capacity_type = "SPOT"  # Specify if you want On-Demand or Spot instances

    instance_market_options {
      market_type = "spot"
      spot_options {
        max_price = "0.20"  # Maximum price you are willing to pay for spot instances
      }
    }

    remote_access {
    ec2_key_pair = "Balaji Mariyappan" # Replace with your SSH key pair name
    }
  }
}

#create node group 2
resource "aws_eks_node_group" "example_nodes2" {
  cluster_name    = "PEPOC-EKS-Cluster"
" # Replace with your SSH key pair name
  }
}

