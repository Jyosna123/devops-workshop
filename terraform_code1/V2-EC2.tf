provider "aws" {
    region = "us-east-1"
}
resource "aws_instance" "demo-server"{
    ami = "ami-0bb84b8ffd87024d8"
    instance_type = "t2.micro"
    key_name = "Mykeypair"
    security_groups=[ "demo-sg1" ]
}
resource "aws_security_group" "demo-sg1" {
    name = "demo-sg1"
    description ="SSH Access"
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