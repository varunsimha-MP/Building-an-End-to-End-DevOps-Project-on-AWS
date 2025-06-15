variable "region" {
  default = "ap-southeast-1"
}
variable "eks_name" {
    default = "testing_k8s"
}

variable "sub_ids" {
  type        = list(string)
}

variable "vpc_id" {
  
}

variable "node_name" {
    default = "test-node-group"
  
}

variable "sg" {
  default = {
    Name = "EKS_Terraform_SG"
  }
}

variable "node_sg" {
  default = {
    Name = "EKS_node_grp_Terraform_SG"
  }
}

variable "eks_ingress_rule" {
  type = map(object({
    port         = number
    protocol     = string
    cidr_block   = list(string)
    description  = string
  }))
}

variable "eks_cluster_policies" {
  default = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSBlockStoragePolicy",
    "arn:aws:iam::aws:policy/AmazonEKSComputePolicy",
    "arn:aws:iam::aws:policy/AmazonEKSLoadBalancingPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSNetworkingPolicy"
  ]
}

variable "eks_node_policies" {
  default = [
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess",
    "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKSLoadBalancingPolicy",
    "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess",
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  ]
  
}