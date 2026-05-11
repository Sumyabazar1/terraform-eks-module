variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "vpc_name" {
  type        = string
  description = "Name tag of the existing VPC."
}

variable "cluster_name" {
  type    = string
  default = "my-eks-cluster"
}

variable "environment" {
  type    = string
  default = "staging"
}
