# variables for vpc block

variable "vpc_cidr" {
  type    = string
  default = "20.20.0.0/16"
}

variable "vpc_name" {
  type    = string
  default = "my-web-vpc"
}

variable "vpc_description" {
  type    = string
  default = "web vpc"
}

variable "vpc_instance_tenancy" {
  type    = string
  default = "default"
}

# subnet variables

variable "subnet_cidr" {
  type    = list(string)
  default = ["10.20.1.0/24", "10.20.2.0/24"]
}

variable "subnet_availability_zone" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}

variable "subnet_name" {
  type    = list(string)
  default = ["subnet01", "subnet02"]
}

#internet gateway variable

variable "igw_name" {
  type    = string
  default = "default-igw"
}

#route table

variable "private_route_table" {
  type    = list(string)
  default = ["private-route-table"]
}

variable "main_default_route_table_name" {
  type    = string
  default = "main-default-route-table"
}

variable "main_default_rt_cidr" {
  type    = string
  default = "0.0.0.0/0"
}

#aws instance

variable "instance_os" {
  type    = string
  default = "ami-0fa3fe0fa7920f68e"
}

variable "os_intsace_type" {
  type    = string
  default = "t2.micro"
}

variable "key_file_name" {
  type    = string
  default = "TF-Jenkin-Server"
}

variable "instance_name" {
  type    = string
  default = "ec2"
}


#security group

variable "security_groups" {
  description = "List of security groups to create"
  type = list(object({
    name        = string
    description = string
    tags        = map(string)
  }))

  default = [
    {
      name        = "jenkin-server-sg"
      description = "allow ssh and jenkins http"
      tags = {
        Name = "jenkins-server"
      }
    }
  ]
}


variable "ingress_rules" {
  description = "List of ingress rules for the security group"
  type = list(object({
    from_port = number
    to_port   = number
    protocol  = string
    cidr      = string
  }))
  default = [
    {
      from_port = 22
      to_port   = 22
      protocol  = "tcp"
      cidr      = "0.0.0.0/0"
    },
    {
      from_port = 8080
      to_port   = 8080
      protocol  = "tcp"
      cidr      = "0.0.0.0/0"
    }
  ]
}

variable "user_data_script" {
  description = "User data script to bootstrap EC2 with Apache"
  type        = string
  default     = <<EOF
#!/bin/bash
sudo dnf update -y
sudo dnf install -y java-17-amazon-corretto.x86_64
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo dnf install jenkins -y
sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo systemctl status jenkins
EOF
}

variable "local" {
  type = list(string)
  default = ["b", "c", "d", "e", "f", "g"]  
}

variable "no_of_instace" {
  type = number
}

variable "no_of_volumes" {
  type = number
}

variable "volume_size" {
  type = number
}



