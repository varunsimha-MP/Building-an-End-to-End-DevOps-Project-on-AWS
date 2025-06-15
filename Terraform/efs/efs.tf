resource "aws_efs_file_system" "eks_efs" {
    creation_token = "eks_efs"
    encrypted =  true
    performance_mode = "generalPurpose"
    throughput_mode = "elastic"
    lifecycle_policy {
      transition_to_ia = "AFTER_14_DAYS"
    } 
    lifecycle_policy {
      transition_to_archive = "AFTER_30_DAYS"
    }
    tags = var.efs
    depends_on = [ var.vpc_id ] 

     
}

resource "aws_efs_mount_target" "efs_mount_eks" {
    file_system_id = aws_efs_file_system.eks_efs.id
    count = length(var.subnet_ids)
    subnet_id = var.subnet_ids[count.index]
    security_groups = [aws_security_group.efs_SG.id]
}



resource "aws_security_group" "efs_SG" {
  name = "EFS_Terraform_SG"
  description = "EKS_Terraform_SG"
  vpc_id = var.vpc_id
  dynamic "ingress" {
    for_each = var.efs_ingress_rule
    content {
        description = "Inbound Rule"
        from_port = ingress.value.port 
        to_port = ingress.value.port
        protocol = ingress.value.protocol
        cidr_blocks = ingress.value.cidr_blocks
        security_groups = ingress.value.security_group
        }
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = var.sg
}
