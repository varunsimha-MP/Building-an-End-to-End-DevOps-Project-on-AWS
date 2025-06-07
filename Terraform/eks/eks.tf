resource "aws_eks_cluster" "main_eks" {
    name = var.eks_name
    role_arn = data.aws_iam_role.cluster_role.arn
    vpc_config {
      subnet_ids = var.sub_ids
      endpoint_private_access = true
      endpoint_public_access = true
      
    }
}

resource "aws_eks_node_group" "mian_node_group" {
  cluster_name = aws_eks_cluster.main_eks
  node_group_name = var.node_name
  node_role_arn = data.aws_iam_role.node_role.arn
  subnet_ids = var.sub_ids

  scaling_config {
    desired_size = 2
    max_size = 4
    min_size = 1
  }

  instance_types = ["t3.medium"]

  depends_on = [ 
    aws_eks_cluster.main_eks,
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_efs_policy,
    aws_iam_role_policy_attachment.eks_node_policy,
    aws_iam_role_policy_attachment.eks_vpc_cni,
    ]
  
}

resource "aws_eks_addon" "eks_vpc_cni" {
    cluster_name = aws_eks_cluster.main_eks.name
    addon_name = "vpc-cni"
    service_account_role_arn = data.aws_iam_role.vpc_cni.arn
  
}

resource "aws_eks_addon" "eks_coredns" {
    cluster_name = aws_eks_cluster.main_eks.name
    addon_name = "coredns"
}

resource "aws_eks_addon" "eke_kube_proxy" {
    cluster_name = aws_eks_cluster.main_eks.name
    addon_name = "kube-proxy"
}

resource "aws_eks_addon" "eks_efs" {
    cluster_name = aws_eks_cluster.main_eks.name
    addon_name = "amazon-efs-csi-driver"
    service_account_role_arn = data.aws_iam_role.efs.arn
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
        protocol = ingress.value.port
        cidr_blocks = [ingress.value.cidr_block]
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


#Roles
data "aws_iam_role" "cluster_role" {
    name = "AmazonEKSAutoClusterRole"
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
    role = data.aws_iam_role.cluster_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSAutoClusterRole"
}

data "aws_iam_role" "node_role" {
  name = "ec2roleforeks"
}

resource "aws_iam_role_policy_attachment" "eks_node_policy" {
    role = data.aws_iam_role.node_role.name
    policy_arn = "arn:aws:iam::aws:policy/ec2roleforeks"
}

data "aws_iam_role" "vpc_cni" {
  name = "AmazonEKSPodIdentityAmazonVPCCNIRole"
}

resource "aws_iam_role_policy_attachment" "eks_vpc_cni" {
  role = data.aws_iam_role.vpc_cni.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSPodIdentityAmazonVPCCNIRole"
}


data "aws_iam_role" "efs" {
  name = "AmazonEKSPodIdentityAmazonEFSCSIDriverRole"
}

resource "aws_iam_role_policy_attachment" "eks_efs_policy" {
  role       = data.aws_iam_role.efs.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEFSCSIDriverPolicy"
}

