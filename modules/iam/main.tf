# // s3 access user role
# resource "aws_iam_role" "s3_access_user_role" {
#   name = "s3-access-user-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         }
#       }
#     ]
#   })
# }

# // s3 access user role policy
# resource "aws_iam_role_policy" "s3_access_user_role_policy" {
#   name = "s3-access-user-role-policy"
#   role = aws_iam_role.s3_access_user_role.id

#   policy = jsonencode({
#     "Version" : "2012-10-17",
#     "Statement" : [
#       {
#         "Sid" : "ObjectActions",
#         "Effect" : "Allow",
#         "Action" : [
#           "s3:PutObject",
#           "s3:GetObject"
#         ],
#         "Resource" : "${var.s3_bucket_arn}/*"
#       },
#       {
#         "Sid" : "BucketActions",
#         "Effect" : "Allow",
#         "Action" : [
#           "s3:ListBucket",
#           "s3:GetBucketLocation"
#         ],
#         "Resource" : "${var.s3_bucket_arn}"
#       }
#     ]
#   })
# }

// ecs execution role
resource "aws_iam_role" "ecs_execution_role" {
  name = "ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

// ecs execution role policy
resource "aws_iam_role_policy" "ecs_execution_role_policy" {
  name = "ecs-execution-role-policy"
  role = aws_iam_role.ecs_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "AllowSecretsAccess"
        Effect   = "Allow"
        Action   = ["secretsmanager:GetSecretValue"]
        Resource = var.creds_arn
      },
      {
        Sid    = "AllowCloudWatchLogging"
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:CreateLogGroup"
        ]
        Resource = [
          "${var.app_log_group_arn}:*",
          "${var.api_log_group_arn}:*"
        ]
      }
    ]
  })
}

// ecs task role
resource "aws_iam_role" "ecs_task_role" {
  name = "ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

// ecs task role policy
resource "aws_iam_role_policy" "ecs_task_role_policy" {
  name = "ecs-task-role-policy"
  role = aws_iam_role.ecs_task_role.id

  // same s3 policy as s3_access_user_role_policy
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "ObjectActions",
        "Effect" : "Allow",
        "Action" : [
          "s3:PutObject",
          "s3:GetObject"
        ],
        "Resource" : "${var.s3_bucket_arn}/*"
      },
      {
        "Sid" : "BucketActions",
        "Effect" : "Allow",
        "Action" : [
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ],
        "Resource" : "${var.s3_bucket_arn}"
      }
    ]
  })
}
