variable "cidr_block" {
  default = ["10.0.0.0/16"]
}

variable "vpc" {
    default =  {
        Name = "Terraform_vpc"
    }
}

variable "ig" {
    default =  {
        Name = "Terraform_ig"
    }
}

variable "rt" {
    default = {
        Name = "Terraform_rt"
    }
  
}

variable "subnet_count" {
    default = 2
}

variable "cidr_block_subnet" {
    default = ["10.0.0.0/26", "10.0.0.64/26", "10.0.0.128/26"]
}

variable "subnet" {
    default = {
        Name = "Teraaform_public_subnet-"
    }
  
}