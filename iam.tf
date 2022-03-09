
# resource "aws_iam_user" "ecs"

// Allow ECS service to interact with LoadBalancers
data "aws_iam_policy_document" "ecs_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_role" {
  assume_role_policy = data.aws_iam_policy_document.ecs_role_policy.json
  name               = "ccr-EcsClusterServiceRole"
}


# resource "aws_iam_role" "ecs_task_role" {
#   assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role_policy.json
#   name               = "ccr-EcsClusterDefaultTaskRole"
# }

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.ecs_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "allow_create_log_groups" {
  statement {
    actions   = ["logs:CreateLogGroup"]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "allow_create_log_groups" {
  policy = data.aws_iam_policy_document.allow_create_log_groups.json
  role   = aws_iam_role.ecs_role.id
}