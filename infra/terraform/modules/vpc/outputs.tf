output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.medcloud_dev.id
}
output "public_subnet_ids" {
  description = "IDs of public subnets"

  value = [
    aws_subnet.public["a"].id,
    aws_subnet.public["b"].id
  ]
}
output "private_subnet_ids" {
  description = "IDs of private subnets"

  value = [
    aws_subnet.private["a"].id,
    aws_subnet.private["b"].id
  ]
}
