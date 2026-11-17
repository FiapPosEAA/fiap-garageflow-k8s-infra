locals {
  sqs_queue_arns = [
    "arn:aws:sqs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:garageflow-*-events",
  ]
  dynamodb_table_arn = "arn:aws:dynamodb:${var.aws_region}:${data.aws_caller_identity.current.account_id}:table/garageflow-executions"
}

# Pods use the AWS SDK default credential chain, which resolves to the node role.
resource "aws_iam_role_policy" "nodes_messaging_and_data" {
  name = "garageflow-sqs-dynamodb-access"
  role = module.eks.node_iam_role_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "SqsEvents"
        Effect = "Allow"
        Action = [
          "sqs:SendMessage",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes",
          "sqs:GetQueueUrl",
        ]
        Resource = local.sqs_queue_arns
      },
      {
        Sid    = "DynamoDbExecutions"
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:Query",
          "dynamodb:DescribeTable",
        ]
        Resource = [
          local.dynamodb_table_arn,
          "${local.dynamodb_table_arn}/index/*",
        ]
      },
    ]
  })
}
