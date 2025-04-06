variable "aws_region" {
  default = "us-east-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "subnet_cidrs" {
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "azs" {
  default = ["us-east-1a", "us-east-1b"]
}

variable "cluster_name" {
  default = "onfinance-cluster"
}

variable "node_instance_type" {
  default = "t3.medium"
}

variable "desired_capacity" {
  default = 2
}

variable "min_capacity" {
  default = 1
}

variable "max_capacity" {
  default = 3
}

variable "db_name" {
  default = "onfinancedb"
}

variable "db_user" {
  default = "admin"
}

variable "db_password" {
  default = "StrongP@ssword123"
}

variable "s3_bucket_name" {
  default = "onfinance-app-bucket"
}
