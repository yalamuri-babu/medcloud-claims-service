resource "aws_vpc" "medcloud_dev" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "medcloud-${var.environment}-vpc"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
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

  tags = {
    Name        = "medcloud-${var.environment}-public-${each.key}"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}

# -------------------------
# Private Subnets
# -------------------------

resource "aws_subnet" "private" {
  for_each = var.private_subnets

  vpc_id            = aws_vpc.medcloud_dev.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name        = "medcloud-${var.environment}-private-${each.key}"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}

# -------------------------
# Internet Gateway
# -------------------------

resource "aws_internet_gateway" "medcloud_dev" {
  vpc_id = aws_vpc.medcloud_dev.id

  tags = {
    Name        = "medcloud-${var.environment}-igw"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
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

  tags = {
    Name        = "medcloud-${var.environment}-public-rt"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}

# -------------------------
# Public Route Associations
# -------------------------

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public["a"].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public["b"].id
  route_table_id = aws_route_table.public.id
}
