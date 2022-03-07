resource "aws_ecs_cluster" "main" {
  name = "ccr-weather-app-EcsCluster"
}

resource "aws_ecs_task_definition" "main" {
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  family                   = "weather-app-fam"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_service_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  container_definitions = jsonencode([{

    name      = "weather-app-container"
    image     = "${var.image_uri}"
    essential = true
    family    = "weather-app-fam"
    portMappings = [{
      protocol      = "tcp"
      containerPort = 3000
      hostPort      = 3000
    }]
  }])
}


resource "aws_ecs_service" "main" {
  name                               = "ccr-weather-app-EcsService"
  cluster                            = aws_ecs_cluster.main.id
  task_definition                    = aws_ecs_task_definition.main.arn
  desired_count                      = 2
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"


  network_configuration {
    security_groups  = [module.networks.ecs_sg_id]
    subnets          = [module.networks.ecs_sg_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = module.networks.alb_target_arn
    container_name   = "weather-app-container"
    container_port   = 3000
  }

  #  lifecycle {
  #    ignore_changes = [task_definition, desired_count]
  #  }
}