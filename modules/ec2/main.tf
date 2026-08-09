
resource "aws_instance" "kaz" {

  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [var.security_group_id]

  user_data = <<EOF
#!/bin/bash
yum update -y
yum install httpd -y
yum install git -y
EOF

  tags = {
    Name = var.instance_name
  }
}