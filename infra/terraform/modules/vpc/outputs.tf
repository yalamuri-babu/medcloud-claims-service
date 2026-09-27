output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.medcloud_dev.id
}
output "public_subnet_ids" {
  description = "IDs of public subnets"

  value = [
    for subnet in aws_subnet.public : subnet.id
  ]
}

output "private_subnet_ids" {
  description = "IDs of private subnets"

  value = [
    for subnet in aws_subnet.private : subnet.id
  ]
}
output "available_azs" {
  description = "Availability Zones available in the current AWS region"
  value       = data.aws_availability_zones.available.names
}
