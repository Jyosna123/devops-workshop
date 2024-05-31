provider "aws" {
    region = "us-east-1"
}
resource "aws_instance" "demo-server"{
    ami = "ami-04b70fa74e45c3917"
    instance_type = "t2.micro"
    key_name = "Mykeypair"
    //security_groups=[ "demo-sg1" ]
    vpc_security_group_ids=[aws_security_group.demo-sg1.id]
    subnet_id=aws_subnet.dpp-public_subent_01.id
for_each = toset(["jenkins-master","build-slave","ansible"])
    tags = {
        Name= "${each.key}"
    }
}
resource "aws_security_group" "demo-sg1" {
    name = "demo-sg1"
    description ="SSH Access"
    vpc_id=aws_vpc.dpp-vpc.id
    ingress {
        description ="shh access"
        from_port =22
        to_port=22
        protocol="tcp"
        cidr_blocks=["0.0.0.0/0"]
    }
    egress{
        from_port=0
        to_port=0
        protocol="-1"
        cidr_blocks=["0.0.0.0/0"]
    }
    tags={
        Name="ssh-prot"
    }
}

resource "aws_vpc" "dpp-vpc" {
    cidr_block = "10.1.0.0/16"
    tags = {
        Name = "dpp-vpc"
    }
}
//Create a Subnet 
resource "aws_subnet" "dpp-public_subent_01" {
    vpc_id = aws_vpc.dpp-vpc.id
    cidr_block = "10.1.1.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-1a"
    tags = {
      Name = "dpp-public_subent_01"
    }
}
resource "aws_subnet" "dpp-public_subent_02" {
    vpc_id = aws_vpc.dpp-vpc.id
    cidr_block = "10.1.2.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-1a"
    tags = {
      Name = "dpp-public_subent_02"
    }
}
//Creating an Internet Gateway 
resource "aws_internet_gateway" "dpp-igw" {
    vpc_id = aws_vpc.dpp-vpc.id
    tags = {
      Name = "dpp-igw"
    }
}
// Create a route table 
resource "aws_route_table" "dpp-public-rt" {
    vpc_id = aws_vpc.dpp-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.dpp-igw.id
    }
}
// Associate subnet with route table

resource "aws_route_table_association" "dpp-rta-public-subent-1" {
    subnet_id = aws_subnet.dpp-public_subent_01.id
    route_table_id = aws_route_table.dpp-public-rt.id
}
