resource "aws_lb" "web_alb" {
  name               = var.load_balancer_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = aws_subnet.public[*].id # Dynamically get subnet IDs from public subnets
}



resource "aws_lb_target_group" "web_tg" {
  name        = "web-target-group"
  port        = 8080
  target_type = "instance"
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id # Dynamically get VPC ID from aws_vpc.main

  health_check {
    path                = var.health_check_path
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.imported_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}


# resource "aws_autoscaling_attachment" "asg_alb_attachment" {
#   autoscaling_group_name = aws_autoscaling_group.web_app_asg.id
#   lb_target_group_arn    = aws_lb_target_group.web_tg.arn
# }


