# Data source to find the latest Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical owner ID
}

# --- 1. Flask Application EC2 ---
resource "aws_instance" "flask_app_ec2" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro" 
  subnet_id                   = aws_subnet.public.id 
  vpc_security_group_ids      = [aws_security_group.devops_sg.id]
  associate_public_ip_address = true
  key_name                    = "your-ssh-key-name" # <<< REPLACE THIS!
  
  # Uses the cloud-init script for the app
  user_data = file("${path.module}/app-init.yml")

  tags = {
    Name = "Flask-App-EC2"
  }
}

# --- 2. SonarQube EC2 (Requires more resources) ---
resource "aws_instance" "sonarqube_ec2" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.medium" # Minimum recommended for SonarQube
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.devops_sg.id]
  associate_public_ip_address = true
  key_name                    = "your-ssh-key-name" # <<< REPLACE THIS!
  
  # Uses the cloud-init script for SonarQube
  user_data = file("${path.module}/sonar-init.yml")
  
  # Add a separate, larger EBS volume for SonarQube data
  root_block_device {
    volume_size = 30 # Default is often 8GB, 30GB is safer for SonarQube
  }

  tags = {
    Name = "SonarQube-EC2"
  }
}

# --- 3. Monitoring (Prometheus/Grafana) EC2 ---
resource "aws_instance" "monitor_ec2" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.devops_sg.id]
  associate_public_ip_address = true
  key_name                    = "your-ssh-key-name" # <<< REPLACE THIS!
  
  # Uses the cloud-init script for monitoring stack
  user_data = file("${path.module}/monitor-init.yml")

  tags = {
    Name = "Monitoring-EC2"
  }
}

# Output the IPs for easy access
output "flask_app_public_ip" {
  value = aws_instance.flask_app_ec2.public_ip
}

output "sonarqube_public_ip" {
  value = aws_instance.sonarqube_ec2.public_ip
}

output "monitor_public_ip" {
  value = aws_instance.monitor_ec2.public_ip
}
