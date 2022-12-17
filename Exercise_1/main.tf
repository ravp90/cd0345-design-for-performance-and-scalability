# TODO: Designate a cloud provider, region, and credentials
provider "aws"{
    shared_credentials_files = ["C:/Users/ravi_/.aws/credentials"]
    region = "us-east-1"
}

resource "aws_default_vpc" "default" {
    tags = {
        Name = "Default VPC"
    }
}

resource "aws_default_subnet" "default-az1" {
    availability_zone = "us-east-1a"
}

# TODO: provision 4 AWS t2.micro EC2 instances named Udacity T2
resource "aws_instance" "Udacity-T2" {
    ami = "ami-0742b4e673072066f"
    instance_type = "t2.micro"
    count = 4
    tags = {
        Name = "Udacity T2"
    }
}


# TODO: provision 2 m4.large EC2 instances named Udacity M4

# resource "aws_instance" "Udacity-M4" {
#     ami = "ami-0742b4e673072066f"
#     instance_type = "m4.large"
#     count = 2
#     tags = {
#         Name = "Udacity M4"
#     }
# }
