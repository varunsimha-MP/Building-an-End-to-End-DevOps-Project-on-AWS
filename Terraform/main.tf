module "vpc" {
  source = "./vpc"
}

module "eks" {
  source = "./eks"
  vpc_id = module.vpc.vpc_id
  sub_ids = module.vpc.subnet_ids
  eks_ingress_rule = {
    "test" = {
      port = 0
      protocol = "-1"
      cidr_block = ["0.0.0.0/0"]
      description = "Allowing full access"
    }
  }
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