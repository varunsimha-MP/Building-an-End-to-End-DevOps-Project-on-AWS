variable "instance_ami" {
  default = "ami-02c7683e4ca3ebf58"
}

variable "instance_type" {
    default = "t2.micro"
}

variable "ec2_name" {
    default = ["Jenkins","Prometheus and Grafana"]
}

variable "vpc_id" {
  
}

variable "subnet_id" {  
}

variable "ec2_ingress_rule" {
    type = map(object({
        port = number
        protocol = string
        cidr_block = list(string)
        description = string
    }))
}

variable "key" {
}

variable "ec2_sg"{
    default = {
        Name ="sg"
    }
}
