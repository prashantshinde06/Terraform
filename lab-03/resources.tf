resource "aws_vpc" "main_vpc" {
  count            = length(var.vpc_cidr)
  provider = aws.east
  cidr_block       = var.vpc_cidr[count.index]
  instance_tenancy = var.vpc_instance_tenancy
  tags = {
    "Name" : "vpc-${count.index}",
    "Description" : var.vpc_description
  }
  lifecycle {
    prevent_destroy = false
  }
}

# resource "aws_subnet" "subnet_01" {
#   depends_on = [ aws_vpc.main_vpc ]   we can use like this
#   availability_zone = "us-east-1a"
#   cidr_block        = "10.20.1.0/24"
#   vpc_id            = aws_vpc.main_vpc[*].id
#   tags = {
#     "Name" : "subnet_01"
#   }
# }
