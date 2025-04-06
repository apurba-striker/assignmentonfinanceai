# AWS
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

# Networking
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidrs" {
  description = "List of CIDRs for subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "azs" {
  description = "Availability Zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

# EKS
variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "onfinance-cluster"
}

variable "node_instance_type" {
  description = "EC2 instance type for EKS nodes"
  type        = string
  default     = "t3.medium"
}

variable "desired_capacity" {
  description = "Desired number of EKS worker nodes"
  type        = number
  default     = 2
}

variable "min_capacity" {
  description = "Minimum number of EKS worker nodes"
  type        = number
  default     = 1
}

variable "max_capacity" {
  description = "Maximum number of EKS worker nodes"
  type        = number
  default     = 3
}

# RDS
variable "db_name" {
  description = "Database name"
  type        = string
  default     = "onfinancedb"
}

variable "db_user" {
  description = "Database username"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

# S3
variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "onfinance-artifacts"
}
