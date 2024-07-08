provider "aws" {
  region = "us-east-2"
}

# Data source to fetch the latest Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

# VPC
resource "aws_vpc" "webserver_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name           = "webserver_vpc"
    tier           = "dev"
    environment    = "dev"
    application    = "webserver"
    iac            = "yes"
    iac_type       = "terraform"
    provisionedby  = "jsidberry"
    supportcontact = "jsidberry"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "webserver_igw" {
  vpc_id = aws_vpc.webserver_vpc.id

  tags = {
    Name           = "webserver_igw"
    tier           = "dev"
    environment    = "dev"
    application    = "webserver"
    iac            = "yes"
    iac_type       = "terraform"
    provisionedby  = "jsidberry"
    supportcontact = "jsidberry"
  }
}

# Subnet
resource "aws_subnet" "webserver_subnet" {
  vpc_id                  = aws_vpc.webserver_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name           = "webserver_subnet"
    tier           = "dev"
    environment    = "dev"
    application    = "webserver"
    iac            = "yes"
    iac_type       = "terraform"
    provisionedby  = "jsidberry"
    supportcontact = "jsidberry"
  }
}

# Security Group to allow web traffic and SSH
resource "aws_security_group" "webserver_sg" {
  vpc_id = aws_vpc.webserver_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ExampleSG"
  }
}

# EC2 Instance
resource "aws_instance" "webserver" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.webserver_subnet.id
#   security_groups = [aws_security_group.webserver_sg.name]

  tags = {
    Name           = "webserver"
    tier           = "dev"
    environment    = "dev"
    application    = "webserver"
    iac            = "yes"
    iac_type       = "terraform"
    provisionedby  = "jsidberry"
    supportcontact = "jsidberry"
  }
}

# Output private IP
output "instance_private_ip" {
  value = aws_instance.webserver.private_ip
}
