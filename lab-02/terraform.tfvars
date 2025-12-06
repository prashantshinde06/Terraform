# initialization value for vpc variables

vpc_cidr = "10.20.0.0/16"
vpc_name = "my-new-web-vpc"
vpc_description = "web server vpc"

#initilization values for subnet

subnet_availability_zone = ["us-east-1a", "us-east-1a"]
subnet_cidr = ["10.20.1.0/24", "10.20.3.0/24"]
subnet_name = [ "my-web-subnet-01" ,"my-web-subnet-02"]

#initialization of igw variable

igw_name = "web-igw"

#initialization for pvt route table

private_route_table = [ "web-private-route-table" ]

no_of_instace = 2
no_of_volumes = 2
volume_size = 5
