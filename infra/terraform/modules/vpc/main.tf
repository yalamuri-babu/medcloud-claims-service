locals {
  common_tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}
data "aws_availability_zones" "available" {
  state = "available"
}
resource "aws_vpc" "medcloud_dev" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
   local.common_tags,
  {
    Name = "medcloud-${var.environment}-vpc"
  }
)
}
# -------------------------
# Public Subnets
# -------------------------

resource "aws_subnet" "public" {
  for_each = var.public_subnets

  vpc_id                  = aws_vpc.medcloud_dev.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = true

    tags = merge(
    local.common_tags,
    {
      Name = "medcloud-${var.environment}-public-${each.key}"
    }
  )
}

# -------------------------
# Private Subnets
# -------------------------

resource "aws_subnet" "private" {
  for_each = var.private_subnets

  vpc_id            = aws_vpc.medcloud_dev.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = merge(
    local.common_tags,
    {
      Name = "medcloud-${var.environment}-private-${each.key}"
    }
)
}

# -------------------------
# Internet Gateway
# -------------------------

resource "aws_internet_gateway" "medcloud_dev" {
  vpc_id = aws_vpc.medcloud_dev.id

  tags = merge(
    local.common_tags,
    {
      Name = "medcloud-${var.environment}-igw"
    }
  )
}

# -------------------------
# Public Route Table
# -------------------------

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.medcloud_dev.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.medcloud_dev.id
  }

  tags = merge(
    local.common_tags,
    {
      Name = "medcloud-${var.environment}-public-rt"
    }
  )
}
# -------------------------
# Public Route Associations
# -------------------------
resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public["a"].id

  tags = merge(
    local.common_tags,
    {
      Name = "medcloud-${var.environment}-nat"
    }
  )
}
# -------------------------
# NAT Elastic IP
# -------------------------

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = merge(
    local.common_tags,
    {
      Name = "medcloud-${var.environment}-nat-eip"
    }
  )
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.medcloud_dev.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = merge(
    local.common_tags,
    {
      Name = "medcloud-${var.environment}-private-rt"
    }
  )
}

resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}

