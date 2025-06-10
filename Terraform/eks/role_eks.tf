data "aws_iam_role" "cluster_role" {
    name = "AmazonEKSAutoClusterRole"
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
    for_each = toset(var.eks_cluster_policies)
    role = data.aws_iam_role.cluster_role.name
    policy_arn = each.value
}

resource "aws_iam_role" "node_role" {
  name = "Terraform_ec2roleforeks"

  # Assume role policy is required, use the same policy used during original creation if available
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    "eks:eks-cluster-name" = var.eks_name
  }
}


resource "aws_iam_role_policy_attachment" "eks_node_policy" {
    for_each = toset(var.eks_node_policies)
    role = aws_iam_role.node_role.name
    policy_arn = each.value
}

resource "aws_iam_role" "vpc_cni_pod_identity_role" {
  name = "Terraform_AmazonEKSPodIdentityAmazonVPCCNIRole"

  assume_role_policy = jsonencode({
    
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "pods.eks.amazonaws.com"
            },
            "Action": [
                "sts:AssumeRole",
                "sts:TagSession"
            ]
        }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "eks_vpc_cni_policy" {
  role       = aws_iam_role.vpc_cni_pod_identity_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}


