data "aws_iam_role" "cluster_role" {
    name = "AmazonEKSAutoClusterRole"
}

data "aws_iam_role" "vpc_cni" {
  name = "AmazonEKSPodIdentityAmazonVPCCNIRole"
}

data "aws_iam_role" "efs" {
  name = "AmazonEKSPodIdentityAmazonEFSCSIDriverRole"
}

data "aws_iam_role" "node_role" {
  name = "ec2roleforeks"
}