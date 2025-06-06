locals {
  azs = data.aws_availability_zones.azs
  subnet_ids = [for subnet in aws_aws_subnet.main_subnet : subnet.id ]
}