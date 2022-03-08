resource "aws_ecr_repository" "main" {
  name                 = "ccr-weather-app"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

# resource "aws_ecr_repository_policy" "this" {
#   repository = aws_ecr_repository.main.name

#   policy = <<EOF
#   {
#     "Version": "2008-10-17",
#     "Statement": [
#         {
#             "Sid": "ECS-Policy",
#             "Effect": "Allow",
#             "Principal": "arn:aws:sts::152848913167:assumed-role/AWSReservedSSO_AdministratorAccess_9a5c1e6656f53c81/conor.chisholm-ray@contino.io",
#             "Action": [
#                 "ecr:GetDownloadUrlForLayer",
#                 "ecr:GetAuthorizationToken",
#                 "ecr:BatchGetImage",
#                 "ecr:BatchCheckLayerAvailability",
#                 "ecr:PutImage",
#                 "ecr:InitiateLayerUpload",
#                 "ecr:UploadLayerPart",
#                 "ecr:CompleteLayerUpload",
#                 "ecr:DescribeRepositories",
#                 "ecr:GetRepositoryPolicy",
#                 "ecr:ListImages",
#                 "ecr:DeleteRepository",
#                 "ecr:BatchDeleteImage",
#                 "ecr:SetRepositoryPolicy",
#                 "ecr:DeleteRepositoryPolicy"
#             ]
#         }
#     ]
#   }
#   EOF 
# }

resource "aws_ecr_lifecycle_policy" "main" {
  repository = aws_ecr_repository.main.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "keep last 10 images"
      action = {
        type = "expire"
      }
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 10
      }
    }]
  })
}

output "repo-name" {
  value = aws_ecr_repository.main.name
}
