variable "subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  
}

variable "efs_ingress_rule" {
  
}

variable "sg" {
  default = {
    Name = "EFS_Terraform_SG"
  }
}

variable "efs" {
  default = {
    Name = "EFS_mount_to_EKS"
  }
  
}