variable "region" {
  default     = "us-east-2"
  description = "Default AWS region"
}
variable "datadog_api_key" {
  default     = ""
  description = "Datadog API KEY"
}
variable "datadog_app_key" {
  default     = ""
  description = "Datadog APP KEY"
}
variable "api_url" {
  default     = "https://api.datadoghq.eu/"
  description = "API default URL address"
}
variable "cluster_name" {
  default     = "NextCloud_Demo"
  description = "EKS cluster name"
}
variable "node_group_name" {
  default     = "Nextcloud_node"
  description = "Worker node group name"
}
variable "tag_name" {
  default     = "Nextcloud"
  description = "Cluster tag name"
}
variable "ssh_keyname" {
  default     = "AWS_key"
  description = "SSH keypair name for remote access"
}
variable "aws_iam_role" {
  default     = "eks-cluster"
  description = "IAM role name"
}
variable "iam_nodes_name" {
  default     = "eks-nodes-nextcloud-demo"
  description = "IAM role name for nodes"
}
