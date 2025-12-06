# variables for vpc block

variable "vpc_cidr" {
  type    = list(string)
  default = ["20.20.1.0/24"]
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

