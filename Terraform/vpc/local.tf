locals {
  azs = data.aws_availability_zones.azs.names
  subnet_ids = [for subnet in aws_subnet.main_subnet : subnet.id ]
}