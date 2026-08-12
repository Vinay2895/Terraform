
# Application Load Balancer


resource "aws_lb" "alb" {

  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    var.security_group_id
  ]

  subnets = var.public_subnet_ids

  tags = {
    Name = var.alb_name
  }
}


# Target Group


resource "aws_lb_target_group" "tg" {

  name     = "${var.alb_name}-tg"
  port     = 80
  protocol = "HTTP"

  target_type = "instance"

  vpc_id = var.vpc_id

  health_check {

    enabled = true

    path = "/"

    protocol = "HTTP"

    interval = 30

    timeout = 5

    healthy_threshold = 3

    unhealthy_threshold = 3
  }

  tags = {
    Name = "${var.alb_name}-tg"
  }
}


# Attach EC2 to Target Group


resource "aws_lb_target_group_attachment" "ec2" {

  target_group_arn = aws_lb_target_group.tg.arn

  target_id = var.target_instance_id

  port = 80
}

# Listener


resource "aws_lb_listener" "http" {

  load_balancer_arn = aws_lb.alb.arn

  port = 80

  protocol = "HTTP"

  default_action {

    type = "forward"

    target_group_arn = aws_lb_target_group.tg.arn
  }
}