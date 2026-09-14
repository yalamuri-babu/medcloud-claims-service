moved {
  from = aws_vpc.medcloud_dev
  to   = module.vpc.aws_vpc.medcloud_dev
}

moved {
  from = aws_subnet.public_a
  to   = module.vpc.aws_subnet.public["a"]
}

moved {
  from = aws_subnet.public_b
  to   = module.vpc.aws_subnet.public["b"]
}

moved {
  from = aws_subnet.private_a
  to   = module.vpc.aws_subnet.private["a"]
}

moved {
  from = aws_subnet.private_b
  to   = module.vpc.aws_subnet.private["b"]
}

moved {
  from = aws_internet_gateway.medcloud_dev
  to   = module.vpc.aws_internet_gateway.medcloud_dev
}

moved {
  from = aws_route_table.public
  to   = module.vpc.aws_route_table.public
}

moved {
  from = aws_route_table_association.public_a
  to   = module.vpc.aws_route_table_association.public_a
}

moved {
  from = aws_route_table_association.public_b
  to   = module.vpc.aws_route_table_association.public_b
}
