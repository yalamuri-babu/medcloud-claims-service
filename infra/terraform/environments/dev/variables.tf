# variables.tf

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}
variable "public_subnets" {
  description = "Public subnet configuration for this environment"
  type = map(object({
    cidr = string
    az   = string
  }))
}

variable "private_subnets" {
  description = "Private subnet configuration for this environment"
  type = map(object({
    cidr = string
    az   = string
  }))
}
variable "cluster_node_config" {
  description = "EKS managed node group configuration"

  type = object({
    instance_type = string
    min_nodes     = number
    desired_nodes = number
    max_nodes     = number
  })
}
