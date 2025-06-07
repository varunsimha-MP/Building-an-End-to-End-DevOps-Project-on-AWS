variable "eks_name" {
    default = "testing_k8s"
}

variable "sub_ids" {
  
}

variable "vpc_id" {
  
}

variable "node_name" {
    default = "test-node-group"
  
}

variable "sg" {
  default = "EKS_Terraform_SG"
}

variable "eks_ingress_rule" {
  
}