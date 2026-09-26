variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "project_name" {
  description = "Project name used for naming and tagging"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for EKS"
  type        = list(string)
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
