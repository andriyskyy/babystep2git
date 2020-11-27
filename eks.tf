resource "aws_key_pair" "cluster_key" {
  key_name   = "ssh-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCPyC716pP9qAP82YCAs5xOp0koAg/alGei4bBYzYjvsMTe36fT6hUPvlzs6rc3qDeIWkFLrME5HiPEFrNt6cHv6LhdTT7cHzJg3kZvYBTzUOx0hDEztk4MYThG91enGOIczC+sRmozsGxys0sQCT3nANL5G27vCrRoknTlhavRIlHctrarjnrwf7aNO4AnKkW7XCSApnHuQaS3HxgxCSpysP3sbHVMXPUYCoqgEZx4naDMVek+nVb9U5IAABQtz9/nZo8mwMQcAJai/16gAVluchdArLgdL0im16P4qh94WIcWK6iiQnni9Rt9qvOYYGIrB/ghj2NWADqmIMDgHqnf"
                                      }
resource "aws_iam_role" "eks_cluster" {
  name = "eks-cluster"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_eks_cluster" "aws_eks" {
  name       = "eks_cluster_test"
  role_arn   = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids = ["subnet-6f453823", "subnet-bd479bd6"]
  }

  tags = {
    Name = "EKS_test"
  }
}

resource "aws_iam_role" "eks_nodes" {
  name = "eks-node-group-tuto"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_eks_node_group" "node" {
  cluster_name    = aws_eks_cluster.aws_eks.name
  node_group_name = "node_test"
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = ["subnet-6f453823", "subnet-bd479bd6"]

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}
