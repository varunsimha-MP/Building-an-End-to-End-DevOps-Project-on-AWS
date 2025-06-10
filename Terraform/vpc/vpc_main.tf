#VPC Creation

resource "aws_vpc" "main_vpc" {
    cidr_block = var.cidr_block
    enable_dns_hostnames = true
    enable_dns_support = true
    tags = var.vpc

}

resource "aws_internet_gateway" "main_ig" {
    vpc_id = aws_vpc.main_vpc.id
    tags = var.ig  
}


resource "aws_route_table" "main_rt" {
    vpc_id = aws_vpc.main_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main_ig.id
    }
    tags = var.rt
}

resource "aws_subnet" "main_subnet" {
    count = var.subnet_count
    vpc_id = aws_vpc.main_vpc.id
    cidr_block = var.cidr_block_subnet[count.index]
    availability_zone = local.azs[count.index]
    map_public_ip_on_launch = true
    tags = {
        "kubernetes.io/role/elb" = "1"
        "kubernetes.io/cluster/testing_k8s" = "shared"
       

        Name = var.subnet[count.index]
    }
}

resource "aws_route_table_association" "main_rt-association-subnet" {
    count = var.subnet_count
    subnet_id = aws_subnet.main_subnet[count.index].id
    route_table_id = aws_route_table.main_rt.id
}
