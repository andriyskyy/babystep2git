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
  default     = "https://api.datadoghq.com/"
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

variable "map_accounts" {
  description = "Additional AWS account numbers to add to the aws-auth configmap."
  type        = list(string)

  default = [
    "837602901840",
    "888888888888",
  ]
}

variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap."
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      rolearn  = "arn:aws:iam::66666666666:role/role1"
      username = "role1"
      groups   = ["system:masters"]
    },
  ]
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      userarn  = "arn:aws:iam::66666666666:user/user1"
      username = "user1"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::66666666666:user/user2"
      username = "user2"
      groups   = ["system:masters"]
    },
  ]
}
