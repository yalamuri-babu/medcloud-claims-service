resource "aws_vpc" "medcloud_dev" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "medcloud-dev-vpc"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}

resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.medcloud_dev.id
  cidr_block              = "10.20.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name        = "medcloud-dev-public-a"
    Environment = "dev"
    Project     = "MedCloud"
    ManagedBy   = "Terraform"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.medcloud_dev.id
  cidr_block              = "10.20.2.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true

  tags = {
    Name        = "medcloud-dev-public-b"
    Environment = "dev"
    Project     = "MedCloud"
    ManagedBy   = "Terraform"
  }
}

resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.medcloud_dev.id
  cidr_block        = "10.20.11.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name        = "medcloud-dev-private-a"
    Environment = "dev"
    Project     = "MedCloud"
    ManagedBy   = "Terraform"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.medcloud_dev.id
  cidr_block        = "10.20.12.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name        = "medcloud-dev-private-b"
    Environment = "dev"
    Project     = "MedCloud"
    ManagedBy   = "Terraform"
  }
}
resource "aws_internet_gateway" "medcloud_dev" {
  vpc_id = aws_vpc.medcloud_dev.id

  tags = {
    Name        = "medcloud-dev-igw"
    Environment = "dev"
    Project     = "MedCloud"
    ManagedBy   = "Terraform"
  }
}
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.medcloud_dev.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.medcloud_dev.id
  }

  tags = {
    Name        = "medcloud-dev-public-rt"
    Environment = "dev"
    Project     = "MedCloud"
    ManagedBy   = "Terraform"
  }
}
resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name        = "medcloud-dev-nat-eip"
    Environment = "dev"
    Project     = "MedCloud"
    ManagedBy   = "Terraform"
  }
}
resource "aws_nat_gateway" "medcloud_dev" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_a.id

  tags = {
    Name        = "medcloud-dev-nat"
    Environment = "dev"
    Project     = "MedCloud"
    ManagedBy   = "Terraform"
  }

  depends_on = [aws_internet_gateway.medcloud_dev]
}
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.medcloud_dev.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.medcloud_dev.id
  }

  tags = {
    Name        = "medcloud-dev-private-rt"
    Environment = "dev"
    Project     = "MedCloud"
    ManagedBy   = "Terraform"
  }
}
resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.private.id
}

