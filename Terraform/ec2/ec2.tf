resource "aws_instance" "ec2" {
    count = 2
    ami = var.instance_ami
    associate_public_ip_address = true
    instance_type = var.instance_type
    subnet_id = slice(var.subnet_id, count.index, count.index+1)[0]
    vpc_security_group_ids = [aws_security_group.ec2_sg.id]
    key_name = var.key
    tags = {
        Name = var.ec2_name[count.index]
    }
    iam_instance_profile = aws_iam_instance_profile.jenkins_instance.name
}

resource "aws_iam_instance_profile" "jenkins_instance" {
    name = "jenkins_instance"
    role = aws_iam_role.ec2_role.name
}

resource "aws_security_group" "ec2_sg" {
    name = "Ec2"
    description = "ec2"
    vpc_id = var.vpc_id

    dynamic "ingress" {
        for_each = var.ec2_ingress_rule
        content {
          description = "inbound rule"
          from_port = ingress.value.port
          to_port = ingress.value.port
          protocol = ingress.value.protocol
          cidr_blocks = ingress.value.cidr_block
        }
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks =["0.0.0.0/0"]
    }
    tags = var.ec2_sg
}