variable "cluster_name" {}
variable "vpc_id" {}
variable "subnet_ids" {
  type = list(string)
}
variable "node_instance_type" {}
variable "desired_capacity" {}
variable "min_capacity" {}
variable "max_capacity" {}
