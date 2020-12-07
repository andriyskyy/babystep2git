variable "datadog_api_key" {
  default     = ""
  description = "Datadog API KEY"
}
variable "datadog_app_key" {
  default     = ""
  description = "Datadog APP KEY"
}
variable "cluster_name" {
  default     = "NextCloud_Demo"
  description = "EKS cluster name"
}
variable "node_group_name"
  default     = "Nextcloud_node"
  description = "Worker node group name"
}
variable "tag_name" {
  default     = "Nextcloud"
  description = "Cluster tag name"
}
variable "ssh_keyname"
  default     = "AWS_key"
  description = "SSH keypair name for remote access"
}
