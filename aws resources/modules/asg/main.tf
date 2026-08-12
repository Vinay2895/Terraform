
# Launch Template

resource "aws_launch_template" "kaz" {

  name_prefix   = var.launch_template_name
  image_id      = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [
    var.security_group_id
  ]

  user_data = base64encode(<<EOF
#!/bin/bash
yum update -y
yum install httpd -y
systemctl enable httpd
systemctl start httpd
echo "Welcome from Auto Scaling Group" > /var/www/html/index.html
EOF
)

  tag_specifications {

    resource_type = "instance"

    tags = {
      Name = var.instance_name
    }
  }
}


# Auto Scaling Group


resource "aws_autoscaling_group" "kaz" {

  name = "kaz-asg"

  min_size         = var.min_size
  max_size         = var.max_size
  desired_capacity = var.desired_capacity

  vpc_zone_identifier = var.private_subnet_ids

  target_group_arns = [
    var.target_group_arn
  ]

  launch_template {

    id      = aws_launch_template.kaz.id
    version = "$Latest"
  }

  health_check_type = "ELB"

  health_check_grace_period = 300

  tag {

    key                 = "Name"

    value               = var.instance_name

    propagate_at_launch = true
  }
}