# network.tf

# 1. Virtual Private Cloud (VPC)
resource "aws_vpc" "devops_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "devops-vpc"
  }
}

# 2. Internet Gateway (to allow traffic out/in)
resource "aws_internet_gateway" "devops_igw" {
  vpc_id = aws_vpc.devops_vpc.id
  tags = {
    Name = "devops-igw"
  }
}

# 3. Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.devops_vpc.id
  cidr_block              = "10.0.1.0/24" # A /24 subnet within the /16 VPC
  map_public_ip_on_launch = true          # CRITICAL for public access
  availability_zone       = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "devops-public-subnet"
  }
}

# 4. Route Table (for public routing)
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.devops_vpc.id
  route {
    cidr_block = "0.0.0.0/0"        # Default route to the internet
    gateway_id = aws_internet_gateway.devops_igw.id
  }
  tags = {
    Name = "devops-public-rt"
  }
}

# 5. Route Table Association
resource "aws_route_table_association" "public_rta" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

# 6. Security Group (Shared by all three EC2s)
# This grants access to the necessary ports for all services
resource "aws_security_group" "devops_sg" {
  name        = "devops_sg"
  description = "Security Group for Flask, SonarQube, and Monitoring EC2s"
  vpc_id      = aws_vpc.devops_vpc.id

  # Ingress: SSH (Port 22) from everywhere (for setup/debugging)
  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Ingress: Flask App (Port 80) from everywhere
  ingress {
    description = "HTTP Access for Flask App"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Ingress: SonarQube (Port 9000) from everywhere
  ingress {
    description = "SonarQube Web UI"
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress: All outbound traffic allowed (needed for package installs, etc.)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "devops-security-group"
  }
}

# Data source to dynamically get an available AZ (best practice)
data "aws_availability_zones" "available" {
  state = "available"
}
