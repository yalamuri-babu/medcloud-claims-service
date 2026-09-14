#environments/dev/
aws_region   = "ap-south-1"
vpc_cidr     = "10.20.0.0/16"
environment  = "dev"
project_name = "MedCloud"
public_subnets = {
  a = {
    cidr = "10.20.1.0/24"
    az   = "ap-south-1a"
  }

  b = {
    cidr = "10.20.2.0/24"
    az   = "ap-south-1b"
  }
}

private_subnets = {
  a = {
    cidr = "10.20.11.0/24"
    az   = "ap-south-1a"
  }

  b = {
    cidr = "10.20.12.0/24"
    az   = "ap-south-1b"
  }
}
