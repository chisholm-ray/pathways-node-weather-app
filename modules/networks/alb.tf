resource "aws_lb" "main" {
  name               = "ccr-weather-app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = [aws_subnet.public["ccr-dojo-public-a"].id, aws_subnet.public["ccr-dojo-public-b"].id, aws_subnet.public["ccr-dojo-public-c"].id]
  
  enable_deletion_protection = false
}
 
resource "aws_alb_target_group" "main" {
  name        = "ccr-weather-app-tg"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"
 
#   health_check {
#    healthy_threshold   = "3"
#    interval            = "30"
#    protocol            = "HTTP"
#    matcher             = "200"
#    timeout             = "3"
#    path                = var.health_check_path
#    unhealthy_threshold = "2"
#   }
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"
 
  default_action {
   type = "forward"
   target_group_arn = aws_alb_target_group.main.arn
  }
}

  #  redirect {
  #    port        = 443
  #    protocol    = "HTTPS"
  #    status_code = "HTTP_301"
  #  }
  # }

 
# resource "aws_alb_listener" "https" {
#   load_balancer_arn = aws_lb.main.id
#   port              = 443
#   protocol          = "HTTPS"
 
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   # certificate_arn   = var.alb_tls_cert_arn
 
#   default_action {
#     target_group_arn = aws_alb_target_group.main.id
#     type             = "forward"
#   }
# }

output "alb_target_arn" {
  value = aws_alb_target_group.main.arn
}