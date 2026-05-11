provider "aws" {
  region = var.aws_region
}

# Fetch existing VPC and private subnets tagged for EKS
data "aws_vpc" "main" {
  tags = { Name = var.vpc_name }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }
  tags = { Tier = "private" }
}

module "eks" {
  source = "../../modules/eks"

  cluster_name       = var.cluster_name
  kubernetes_version = "1.30"
  vpc_id             = data.aws_vpc.main.id
  subnet_ids         = data.aws_subnets.private.ids

  # Lock down the API server — access only from within the VPC
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = false

  enable_irsa               = true
  enable_cluster_encryption = true
  enable_ebs_csi_driver     = true

  node_groups = {
    system = {
      instance_types = ["m6i.large"]
      min_size       = 2
      desired_size   = 2
      max_size       = 4
      disk_size_gb   = 50
      labels = {
        role = "system"
      }
    }

    workload = {
      instance_types = ["r6i.2xlarge"]
      min_size       = 0
      desired_size   = 2
      max_size       = 10
      disk_size_gb   = 100
      labels = {
        role = "workload"
      }
    }
  }

  tags = {
    Environment = var.environment
    Team        = "platform"
  }
}
