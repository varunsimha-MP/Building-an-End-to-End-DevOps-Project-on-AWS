variable "subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  
}

variable "eks_ac" {
  default = {
    Name = "EKS_AC"
  }
}

variable "efs_ingress_rule" {
    type = map(object({
        port = number
        protocol = string
        cidr_blocks= list(string)
        description = string
        security_group = list(string)
    }))
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