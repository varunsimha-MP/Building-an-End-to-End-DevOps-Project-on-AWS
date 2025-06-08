resource "aws_eks_cluster" "main_eks" {
    name = var.eks_name
    role_arn = data.aws_iam_role.cluster_role.arn
    vpc_config {
      subnet_ids = var.sub_ids
      endpoint_private_access = true
      endpoint_public_access = true
      security_group_ids = [aws_security_group.eks_SG.id]
    }
    depends_on = [aws_iam_role_policy_attachment.eks_cluster_policy  ]
}

resource "aws_eks_addon" "eks_vpc_cni" {
    cluster_name = aws_eks_cluster.main_eks.name
    addon_name = "vpc-cni"
    service_account_role_arn = data.aws_iam_role.vpc_cni.arn
    depends_on = [ aws_eks_cluster.main_eks ]
  
}

resource "aws_eks_addon" "eke_kube_proxy" {
    cluster_name = aws_eks_cluster.main_eks.name
    addon_name = "kube-proxy"
    depends_on = [ aws_eks_cluster.main_eks ]
}

resource "aws_eks_node_group" "main_node_group" {
  cluster_name = aws_eks_cluster.main_eks.name
  node_group_name = var.node_name
  node_role_arn = data.aws_iam_role.node_role.arn
  subnet_ids = var.sub_ids
  remote_access {
    ec2_ssh_key = "singapure-key"
    source_security_group_ids = [aws_security_group.eks_node_grp_SG.id]
  }

  scaling_config {
    desired_size = 2
    max_size = 4
    min_size = 1
  }
  ami_type = "AL2_86_64"
  instance_types = ["t3.medium"]
  disk_size = 30
  capacity_type = "ON_DEMAND"

  depends_on = [ 
    aws_eks_cluster.main_eks,
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_efs_policy,
    aws_iam_role_policy_attachment.eks_node_policy,
    aws_iam_role_policy_attachment.eks_vpc_cni,
    ]
  
}

resource "aws_security_group" "eks_SG" {
  name = "EKS_Terraform_SG"
  description = "EKS_Terraform_SG"
  vpc_id = var.vpc_id
  dynamic "ingress" {
    for_each = var.eks_ingress_rule
    content {
        description = "Inbound Rule"
        from_port = ingress.value.port 
        to_port = ingress.value.port
        protocol = ingress.value.protocol
        cidr_blocks = ingress.value.cidr_block
        }
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = var.sg
}

resource "aws_security_group" "eks_node_grp_SG" {
  name = "EKS_node_grp_Terraform_SG"
  description = "EKS_node_grp_Terraform_SG"
  vpc_id = var.vpc_id
  dynamic "ingress" {
    for_each = var.eks_node_grp_ingress_rule
    content {
        description = "Inbound Rule"
        from_port = ingress.value.port 
        to_port = ingress.value.port
        protocol = ingress.value.protocol
        cidr_blocks = ingress.value.cidr_block
        }
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = var.node_sg
}




