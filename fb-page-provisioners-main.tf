# Define the AWS provider configuration.
provider "aws" {
  region = "us-east-1"  

}

resource "aws_vpc" "myvpc" {
  cidr_block = "10.81.0.0/16"
  instance_tenancy = "default"

   tags = {
    Name = "myvpc"
  }
}

resource "aws_subnet" "sub1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.81.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "sub1"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id
}

resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.sub1.id
  route_table_id = aws_route_table.RT.id
}

resource "aws_security_group" "b16Sg" {
  name   = "b16Sg"
  vpc_id = aws_vpc.myvpc.id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "http"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "b16-Sg"
  }
}

resource "aws_instance" "fb-server" {
  ami = "ami-084a7d336e816906b"
  instance_type = "t2.micro"
  key_name = "b16key"
  vpc_security_group_ids = [aws_security_group.b16Sg.id]
  subnet_id              = aws_subnet.sub1.id


  provisioner "local-exec" {
    command = "echo 'hello batch16 champs' > batch16.txt"
  }

   connection {
    type     = "ssh"
    user     = "ec2-user"
   # private_key = file("C:/Users/Dell/Desktop/keys/madhukey.pem") 
    private_key = file("C:/Users/Madhu Kiran/Desktop/b16-keys/b16key.pem") 
    host        = self.public_ip 
          }

    # File provisioner to copy a file from local to the remote EC2 instance
 provisioner "file" {
    source      = "index.html"  
    destination = "/tmp/index.html"  
  } 

   provisioner "remote-exec" {
   inline = [
     "sudo yum install httpd -y",
     "sudo systemctl start httpd",
     "sudo systemctl enable httpd",
     "sudo cp /tmp/index.html  /var/www/html/index.html"
    ] 

  }
  tags = {
    Name = "FB-SERVER"
  }

   }


   output "name" {
     value = aws_instance.fb-server.public_ip
   }
