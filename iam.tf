
data "aws_iam_policy_document" "ecr_access_policy_document" {
  statement {
    actions   = [
                "ecr:BatchCheckLayerAvailability",
                "ecr:BatchGetImage",
                "ecr:GetDownloadUrlForLayer",
                "ecr:GetAuthorizationToken"
              ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "ecr_access_policy"{
  name = "ecr_access_policy"
  path = "/"
  policy = data.aws_iam_policy_document.ecr_access_policy_document.json
}

resource "aws_iam_role_policy_attachment" "ecr_attachment" {
  role        = aws_iam_role.ecs_role.name
  policy_arn  = aws_iam_policy.ecr_access_policy.arn 
}

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