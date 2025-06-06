module "vpc" {
  source = "./vpc"
}

module "eks" {
  source = "./eks"
  vpc_id = module.vpc.vpc_id
  sub_ids = module.vpc.subnet_ids

}