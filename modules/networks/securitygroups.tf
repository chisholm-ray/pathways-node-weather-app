resource "aws_security_group" "alb" {
  name   = "ccr-alb-sg"
  vpc_id = aws_vpc.main.id
 
  ingress {
   protocol         = "tcp"
   from_port        = 80
   to_port          = 80
   cidr_blocks      = ["0.0.0.0/0"]
   self             = true
  }
 
  egress {
   protocol         = "-1"
   from_port        = 0
   to_port          = 0
   cidr_blocks      = ["0.0.0.0/0"]
   self             = true
  }
}

resource "aws_security_group" "ecs_tasks" {
  name   = "ccr-ecsTasks-sg"
  vpc_id = aws_vpc.main.id
  # ingress {
  #  protocol         = "tcp"
  #  from_port        = 80
  #  to_port          = 80
  #  cidr_blocks      = ["0.0.0.0/0"]
  #  ipv6_cidr_blocks = ["::/0"]
  # }

  # ingress {
  #  protocol         = "tcp"
  #  from_port        = 53
  #  to_port          = 53
  #  cidr_blocks      = ["0.0.0.0/0"]
  #  ipv6_cidr_blocks = ["::/0"]
  # }

  # ingress {
  #  protocol         = "tcp"
  #  from_port        = 443
  #  to_port          = 443
  #  cidr_blocks      = ["0.0.0.0/0"]
  #  ipv6_cidr_blocks = ["::/0"]
  # }

  ingress {
   protocol         = "all"
   from_port        = 0
   to_port          = 0
   cidr_blocks      = ["10.0.10.0/24"]
   self             = true
  }

  ingress {
   protocol         = "all"
   from_port        = 0
   to_port          = 0
   security_groups  = [aws_security_group.alb.id]
  }
 
  egress {
   protocol         = "-1"
   from_port        = 0
   to_port          = 0
   cidr_blocks      = ["0.0.0.0/0"]
   ipv6_cidr_blocks = ["::/0"]
   self             = true
  }
}

# resource "aws_security_group" "s3_endpoint" {
#   name   = "ccr-s3-endpoint-sg"
#   vpc_id = aws_vpc.main.id
  
#   ingress {
#    protocol         = "icmp"
#    from_port        = -1
#    to_port          = -1
#    cidr_blocks      = ["10.0.10.0/24"]
#    ipv6_cidr_blocks = ["::/0"]
#   }
 
# }

output "alb_sg_id" {
  value = aws_security_group.alb.id
}

output "ecs_sg_id" {
  value = aws_security_group.ecs_tasks.id  
}