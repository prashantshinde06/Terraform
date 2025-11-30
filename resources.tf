resource "aws_vpc" "main_vpc" {
  cidr_block       = "10.20.0.0/16"
  instance_tenancy = "default"
  tags = {
    "Name" : "Web-app-vpc",
    "Description" : "The main_vpc created using TF"
  }
}

resource "aws_subnet" "subnet_01" {
  availability_zone = "us-east-1a"
  cidr_block        = "10.20.1.0/24"
  vpc_id            = aws_vpc.main_vpc.id
  tags = {
    "Name" : "subnet_01"
  }
}


resource "aws_subnet" "subnet_02" {
  availability_zone = "us-east-1a"
  cidr_block        = "10.20.2.0/24"
  vpc_id            = aws_vpc.main_vpc.id
  tags = {
    "Name" : "subnet_02"
  }
}

resource "aws_internet_gateway" "main_vpc_gw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    "Name" : "main_vpc_gw"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    "Name" : "Private_route_table"
  }
}

resource "aws_route_table_association" "private_subnet-01_association" {
  subnet_id      = aws_subnet.subnet_01.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_default_route_table" "default_route_subnet_02" {
  default_route_table_id = aws_vpc.main_vpc.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_vpc_gw.id
  }
  tags = {
    "Name" : "Default route table"
  }
}

resource "aws_security_group" "jenkins-server-sg" {
  name        = "jenkin-server-sg"
  description = "allow ssh and jenkin http"
  vpc_id      = aws_vpc.main_vpc.id
  tags = {
    "Name" : "jenkins-server"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.jenkins-server-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_jenkins" {
  security_group_id = aws_security_group.jenkins-server-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 8080
  ip_protocol       = "tcp"
  to_port           = 8080
}

resource "aws_instance" "subnet_02_jenkin_server" {
  ami                         = "ami-0fa3fe0fa7920f68e"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.subnet_02.id
  associate_public_ip_address = true
  key_name                    = "TF-Jenkin-Server"
  vpc_security_group_ids      = [aws_security_group.jenkins-server-sg.id]
  tags = {
    "Name" : "Jenkin-Server"
  }
}
