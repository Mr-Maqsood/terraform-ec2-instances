
# -----------------------------
# Provider configuration
# -----------------------------
provider "aws" {
  region = "us-east-2"   # apne AWS region ke hisaab se change karein
}

# -----------------------------
# Key Pair (for SSH login)
# -----------------------------
resource "aws_key_pair" "my_key" {
  key_name   = "terra-key-ec2"
  public_key = file("terra-key-ec2.pub")
}

# -----------------------------
# Default VPC
# -----------------------------
resource "aws_default_vpc" "default" {}

# -----------------------------
# Security Group
# -----------------------------
resource "aws_security_group" "my_security_group" {
  name        = "automate-sg"
  description = "Terraform generated Security Group"
  vpc_id      = aws_default_vpc.default.id

  # Ingress rules
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH access"
  }
   ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP access"
  }

 
  # Egress rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic"
  }

  tags = {
    Name = "automate-sg"
  }
}

# -----------------------------
# EC2 Instance
# -----------------------------
resource "aws_instance" "my_instance" {
  ami                    = var.ec2_ami_id # Ubuntu
  for_each = tomap({
    "TWS-JUNOON-automate-micro" = "t3.micro"
    "TWS-JUNOON-automate-small" = "t3.small"
   
    
  })#meta argument
  depends_on = [aws_security_group.my_security_group, aws_key_pair.my_key]
  instance_type          = each.value
  key_name               = aws_key_pair.my_key.key_name
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
  user_data = file("install_inginx.sh")

  root_block_device {
    volume_size = var.env == "prd" ? 20 : var.ec2_default_root_storage_size
    volume_type = "gp3"
  }

  tags = {
    Name = each.key
  }
}
resource "aws_instance" "my-new-instance" {
  ami = "unknown"
  instance_type = "unknown"
  
}
