module "vpc" {
  source = "./vpc"
}

module "ec2" {
  source = "./ec2"
  vpc_id = module.vpc.vpc_id
  subnet_id = module.vpc.subnet_ids
  key = "singapure-key"
  ec2_ingress_rule = {
    "all" = {
      port = 0
      protocol = "-1"
      cidr_block = ["0.0.0.0/0"]
      description = "Allowing All Traffic"
    }
    "SSH" = {
      port = 22
      protocol = "tcp"
      cidr_block = ["0.0.0.0/0"]
      description = "Allowing SSH traffic"
    }
  }
}

module "dns" {
  source = "./Route53_ACM"
}

module "eks" {
  source = "./eks"
  vpc_id = module.vpc.vpc_id
  sub_ids = module.vpc.subnet_ids
  eks_ingress_rule = {
    "all" = {
      port = 0
      protocol = "-1"
      cidr_block = ["0.0.0.0/0"]
      description = "Allowing All Traffic"
    }
    "SSH" = {
      port = 22
      protocol = "tcp"
      cidr_block = ["0.0.0.0/0"]
      description = "Allowing SSH traffic"
    }
  }
  depends_on = [ module.ec2 ]
}

module "efs" {
  source = "./efs"
  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.subnet_ids
  efs_ingress_rule = {
    "efs_inbound" = {
      port = 2049
      protocol = "TCP"
      cidr_blocks = []
      description = "Allow NFS access from EKS nodes"
      security_group = [module.eks.security_group]
    }
  }
  depends_on = [module.eks]
}

module "ecr" {
  source = "./ecr"
}