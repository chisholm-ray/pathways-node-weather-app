module "ecs" {
  source = "terraform-aws-modules/ecs/aws"

  name = "ccr-ecs-cluster"

  container_insights = true

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy = [
    {
      capacity_provider = "FARGATE"
    }
  ]
}

resource "aws_ecs_task_definition" "main" {
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  family                   = "ccr-task"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ccr_ecs_role.arn
  task_role_arn            = aws_iam_role.ccr_ecs_role.arn
  container_definitions = <<DEFINITION
  [
    {
    "name": "ccr-weather-app-container",
    "image": "${aws_ecr_repository.main.repository_url}:1",
    "essential": true,
    "portMappings": [
      {
      "protocol": "tcp",
      "containerPort": 3000,
      "hostPort": 3000
      }
    ]
  }
 ]
  DEFINITION
}


resource "aws_ecs_service" "main" {
  name                               = "ccr-weather-app-ecsService"
  cluster                            = module.ecs.ecs_cluster_id
  task_definition                    = aws_ecs_task_definition.main.arn
  desired_count                      = 1
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"
  force_new_deployment               = true
#"${aws_ecs_task_definition.main.family}:${max(aws_ecs_task_definition.main.revision, data.aws_ecs_task_definition.main.revision)}"  

  network_configuration {
    security_groups  = [module.networks.ecs_sg_id, module.networks.alb_sg_id]
    subnets          = [module.networks.private_subnet_a, module.networks.private_subnet_b, module.networks.private_subnet_c]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = module.networks.alb_target_arn
    container_name   = "ccr-weather-app-container"
    container_port   = 3000
  }

  #  lifecycle {
  #    ignore_changes = [task_definition, desired_count]
  #  }
}

data "aws_ecs_task_definition" "main" {
  task_definition = aws_ecs_task_definition.main.family
}