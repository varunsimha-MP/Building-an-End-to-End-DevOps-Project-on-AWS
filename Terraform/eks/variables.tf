variable "eks_name" {
    default = "testing_k8s"
}

variable "cluster_role_arn" {
  
}

variable "sub_ids" {
  
}

variable "vpc_id" {
  
}

variable "node_name" {
    default = "test-node-group"
  
}

variable "node_role_arn" {
  
}

variable "sg" {
  default = "EKS_Terraform_SG"
}

variable "eks_ingress_rule" {
  
}