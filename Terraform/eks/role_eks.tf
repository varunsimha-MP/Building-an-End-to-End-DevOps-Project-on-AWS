data "aws_iam_role" "cluster_role" {
    name = "AmazonEKSAutoClusterRole"
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
    for_each = toset(var.eks_cluster_policies)
    role = data.aws_iam_role.cluster_role.name
    policy_arn = each.value
}

data "aws_iam_role" "node_role" {
  name = "ec2roleforeks"
}

resource "aws_iam_role_policy_attachment" "eks_node_policy" {
    for_each = toset(var.eks_node_policies)
    role = data.aws_iam_role.node_role.name
    policy_arn = each.value
}

data "aws_iam_role" "vpc_cni" {
  name = "AmazonEKSPodIdentityAmazonVPCCNIRole"
}

resource "aws_iam_role_policy_attachment" "eks_vpc_cni" {
  role = data.aws_iam_role.vpc_cni.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}


data "aws_iam_role" "efs" {
  name = "AmazonEKSPodIdentityAmazonEFSCSIDriverRole"
}

resource "aws_iam_role_policy_attachment" "eks_efs_policy" {
  role       = data.aws_iam_role.efs.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
}