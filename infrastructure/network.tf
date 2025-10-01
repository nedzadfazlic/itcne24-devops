# Define a standard VPC, Subnet, and Internet Gateway if you don't have them already.
# If your lab gives you an existing VPC, replace this block with a data source block.

resource "aws_vpc" "devops_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "DevOps-VPC"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.devops_vpc.id
  tags = {
    Name = "DevOps-IGW"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.devops_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a" # Change AZ as needed
  tags = {
    Name = "DevOps-Public-Subnet"
  }
}

# --- Shared Security Group ---
resource "aws_security_group" "devops_sg" {
  name        = "devops-stack-sg"
  description = "Allows inter-VM communication and public access for services"
  vpc_id      = aws_vpc.devops_vpc.id

  # 1. ALLOW ALL TRAFFIC INTERNALLY (Prometheus scraping the App)
  ingress {
    description = "Self-referencing rule for internal communication"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  # 2. PUBLIC ACCESS RULES (Open to 0.0.0.0/0 for testing)
  # IMPORTANT: For production, restrict 'cidr_blocks' to your office/VPN IP range.
  dynamic "ingress" {
    for_each = [
      { port = 22, name = "SSH" },          # Access to all EC2s
      { port = 80, name = "Flask-App" },    # Access to the application
      { port = 3000, name = "Grafana" },    # Access to Grafana UI
      { port = 9000, name = "SonarQube" },  # Access to SonarQube UI
      { port = 9090, name = "Prometheus" }  # Access to Prometheus UI
    ]
    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"] 
    }
  }

  # 3. ALLOW ALL OUTBOUND TRAFFIC
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
