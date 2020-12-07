resource "aws_iam_role" "eks_cluster" {
  name = var.aws_iam_role

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
  name       = var.cluster_name
  role_arn   = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids = ["subnet-6f453823", "subnet-bd479bd6"]
  }

  tags = {
    Name = var.tag_name
  }
}

resource "aws_iam_role" "eks_nodes" {
  name = var.iam_nodes_name

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
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = ["subnet-6f453823", "subnet-bd479bd6"]

  scaling_config {
    desired_size  = 1
    max_size      = 1
    min_size      = 1    
  }
  remote_access {
    ec2_ssh_key   = var.ssh_keyname
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}
resource "kubernetes_deployment" "example" {
  metadata {
    name    = "terraform-test"
    labels  = {
      test  = "MyExampleApp"
    }
  }
  
  spec {
    replicas = 2
    
    selector {
      match_labels = {
        test = "MyExampleApp"
      }
     }
    template {
      metadata {
        labels = {
          test = "MyExampleApp"
        }
     }
      spec {
        container {
          image = "nginx:1.7.8"
          name  = "example"
        resources {
          limits {
            cpu     = "0.5"
            memory  = "512Mi"
          }
          requests {
            cpu     = "250m"
            memory  = "50Mi"
         }
        }
       }
      }
     }
    }
}
          

