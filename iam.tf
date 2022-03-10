
resource "aws_iam_policy" "ecr_access_policy" {
  name     = "ccr_ecr_access_policy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr:BatchCheckLayerAvailability",
                "ecr:BatchGetImage",
                "ecr:GetDownloadUrlForLayer",
                "ecr:GetAuthorizationToken"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecr_attachment" {
  role        = aws_iam_role.ccr_ecs_role.name
  policy_arn  = aws_iam_policy.ecr_access_policy.arn
}


resource "aws_iam_role" "ccr_ecs_role" {
  name = "ccr-ecs-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ecs-tasks.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}


# data "aws_iam_policy_document" "allow_create_log_groups" {
#   statement {
#     actions   = ["logs:CreateLogGroup"]
#     resources = ["*"]
#   }
# }

# resource "aws_iam_role_policy" "allow_create_log_groups" {
#   policy = data.aws_iam_policy_document.allow_create_log_groups.json
#   role   = aws_iam_role.ecs_role.id
# }