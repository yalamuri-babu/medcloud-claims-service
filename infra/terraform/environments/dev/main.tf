module "vpc" {
  source = "../../modules/vpc"

  project_name = var.project_name
  environment  = var.environment
  vpc_cidr     = var.vpc_cidr

  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}
module "eks" {
  source = "../../modules/eks"

  cluster_name       = "medcloud-${var.environment}-eks"
  environment        = var.environment
  project_name       = var.project_name
  private_subnet_ids = module.vpc.private_subnet_ids

  cluster_node_config = var.cluster_node_config
}
