resource "aws_vpc" "main_vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = var.vpc_instance_tenancy
  tags = {
    "Name" : var.vpc_name,
    "Description" : var.vpc_description
  }
}

resource "aws_subnet" "subnet" {
  count             = length(var.subnet_cidr)
  availability_zone = var.subnet_availability_zone[count.index]
  cidr_block        = var.subnet_cidr[count.index]
  vpc_id            = aws_vpc.main_vpc.id
  tags = {
    "Name" : var.subnet_name[count.index]
  }
}


resource "aws_internet_gateway" "main_vpc_gw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    "Name" : var.igw_name
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    "Name" : var.private_route_table[0]
  }
}

resource "aws_route_table_association" "private_subnet-01_association" {
  subnet_id      = aws_subnet.subnet[0].id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_default_route_table" "default_route_subnet_02" {
  default_route_table_id = aws_vpc.main_vpc.default_route_table_id
  route {
    cidr_block = var.main_default_rt_cidr
    gateway_id = aws_internet_gateway.main_vpc_gw.id
  }
  tags = {
    "Name" : var.main_default_route_table_name
  }
}

resource "aws_security_group" "sg" {
  for_each = {
    for sg in var.security_groups :
    sg.name => sg
  }

  name        = each.value.name
  description = each.value.description
  vpc_id      = aws_vpc.main_vpc.id
  tags        = each.value.tags
}



resource "aws_vpc_security_group_ingress_rule" "sg_ingress" {
  for_each          = { for idx, rule in var.ingress_rules : idx => rule }
  security_group_id = aws_security_group.sg["jenkin-server-sg"].id
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  ip_protocol       = each.value.protocol
  cidr_ipv4         = each.value.cidr
}


# resource "aws_instance" "ec2_server" {
#   ami                         = var.instance_os
#   instance_type               = var.os_intsace_type
#   subnet_id                   = aws_subnet.subnet[1].id
#   associate_public_ip_address = true
#   key_name                    = var.key_file_name
#   vpc_security_group_ids      = [aws_security_group.sg["jenkin-server-sg"].id]
#   user_data = var.user_data_script
#   tags = {
#     "Name" : var.instance_name
#   }
# }

resource "aws_instance" "ec2_server" {
  count                       = var.no_of_instace
  ami                         = var.instance_os
  instance_type               = var.os_intsace_type
  subnet_id                   = aws_subnet.subnet[1].id
  associate_public_ip_address = true
  key_name                    = var.key_file_name
  vpc_security_group_ids      = [aws_security_group.sg["jenkin-server-sg"].id]
  user_data                   = var.user_data_script
  tags = {
    "Name" : "${var.instance_name}-${count.index}"
  }
}

resource "aws_ebs_volume" "extra_volume" {
  count             = var.no_of_instace * var.no_of_volumes
  availability_zone = aws_subnet.subnet[1].availability_zone
  size              = var.volume_size
  tags = {
    Name = "extra-volume-${floor(count.index / 2)}-${count.index % 2}"
  }
}


resource "aws_volume_attachment" "attach_volume" {
  count       = var.no_of_instace * var.no_of_volumes
  device_name = "/dev/sd${var.local[count.index % 2]}"
  volume_id   = aws_ebs_volume.extra_volume[count.index].id
  instance_id = aws_instance.ec2_server[floor(count.index / 2)].id
}

