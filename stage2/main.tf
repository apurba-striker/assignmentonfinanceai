provider "aws" {
  region = var.aws_region
}

module "networking" {
  source       = "./modules/networking"
  vpc_cidr     = var.vpc_cidr
  subnet_cidrs = var.subnet_cidrs
  azs          = var.azs
}

module "eks" {
  source             = "./modules/eks"
  cluster_name       = var.cluster_name
  vpc_id             = module.networking.vpc_id
  subnet_ids         = module.networking.subnet_ids
  node_instance_type = var.node_instance_type
  desired_capacity   = var.desired_capacity
  min_capacity       = var.min_capacity
  max_capacity       = var.max_capacity
}

module "rds" {
  source      = "./modules/rds"
  db_name     = var.db_name
  db_user     = var.db_user
  db_password = var.db_password
  vpc_id      = module.networking.vpc_id
  subnet_ids  = module.networking.subnet_ids
}

module "s3" {
  source      = "./modules/s3"
  bucket_name = var.s3_bucket_name
}

module "iam" {
  source = "./modules/iam"
}
