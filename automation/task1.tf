provider "aws" {
  version    = "~> 2.0"
  access_key = "ASIASAJMUI6BGRG654NG"
  secret_key = "UQ4416w+dofr6DLWNFxxz+P5xu1TUMenaiIY6nv2"
  token      = "FwoGZXIvYXdzEIv//////////wEaDDdYs/XqQ6G7TatceSLAAVQgcc3A1C+ynOVXONmL6YgpDGClC2Gi5QfMoXsAypyQ2HU92UuH7f10ncA0okPJAdSsuZYFQJ1hY77xoeaIGVbIz5f8+qFAMuGkUN2wtPFEu6bahV9aT1LJG63rCnP6ShstZaJC7+EcR2vuGJh08Qlp6nk/Gi1FzyJ6sbj7hSLUdfzmaAUVR7kLXOvLisCNHoHy2KS3mlszU1QXdcTlfo/4We8l22aj052eLTEHa4KasPHfdvLZjVD4rm/oR3aZjSjyi930BTItjp+vaMLCGtJkNzTk6pEH6RZUiS6s+IOriF/ibgdRbj7yh6NICrOedJw5xobG"
  region     = "us-east-1"
}

# Create a VPC
resource "aws_vpc" "tf_vpc" {
  cidr_block = "192.160.0.0/16"
  tags = {
    Name = "Tf_Vpc"
  }
}

resource "aws_subnet" "tf_public_subnet_1" {
  vpc_id                  = "${aws_vpc.tf_vpc.id}"
  cidr_block              = "192.160.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "Tf_public_subnet_1"
  }
}

resource "aws_subnet" "tf_public_subnet_2" {
  vpc_id                  = "${aws_vpc.tf_vpc.id}"
  cidr_block              = "192.160.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "Tf_public_subnet_2"
  }
}

resource "aws_subnet" "tf_private_subnet_1" {
  vpc_id                  = "${aws_vpc.tf_vpc.id}"
  cidr_block              = "192.160.3.0/24"
  availability_zone       = "us-east-1c"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "Tf_private_subnet_1"
  }
}

resource "aws_subnet" "tf_private_subnet_2" {
  vpc_id                  = "${aws_vpc.tf_vpc.id}"
  cidr_block              = "192.160.4.0/24"
  availability_zone       = "us-east-1d"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "Tf_private_subnet_2"
  }
}




resource "aws_internet_gateway" "tf_igw" {
  vpc_id = aws_vpc.tf_vpc.id
}


resource "aws_route_table" "tf_table-public" {
  vpc_id = aws_vpc.tf_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf_igw.id
  }

  tags = {
    Name = "TF Table Public Subnet"
  }
}

resource "aws_route_table_association" "tf_tabAssoc" {
  subnet_id      = aws_subnet.tf_public_subnet_1.id
  route_table_id = aws_route_table.tf_table-public.id
}







resource "aws_security_group" "tf_secgp" {
  name        = "Tf_secgp"
  description = "tf_security_group"
  vpc_id      = "${aws_vpc.tf_vpc.id}"
}

resource "aws_security_group_rule" "tf_secrule1" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.tf_secgp.id
}

resource "aws_security_group_rule" "tf_secrule2" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.tf_secgp.id
}




# data "aws_ami" "ubuntu" {
#   most_recent = true
#
#   filter {
#     name   = "name"
#     values = ["amzn2-ami-hvm-2.0.20200406.0-x86_64-gp2"]
#   }
#
#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }
#
#   owners = ["138069428098"]
# }



resource "aws_instance" "tf_instance1" {
  ami                    = "ami-0323c3dd2da7fb37d"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.tf_secgp.id]
  subnet_id              = aws_subnet.tf_public_subnet_1.id
  key_name               = "project_key_pair"
  user_data              = filebase64("${path.module}/userdata.sh")

}
