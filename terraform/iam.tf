locals {
  sqs_queue_arns = [
    "arn:aws:sqs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:garageflow-*-events",
  ]
  dynamodb_table_arn = "arn:aws:dynamodb:${var.aws_region}:${data.aws_caller_identity.current.account_id}:table/garageflow-executions"
  app_namespace      = "garage-flow-namespace"
}

# Pods do EKS Auto Mode não alcançam o IMDS do nó; as credenciais vêm do EKS Pod Identity.
resource "aws_iam_role" "app_pods" {
  name = "garageflow-app-pods"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "pods.eks.amazonaws.com" }
      Action    = ["sts:AssumeRole", "sts:TagSession"]
    }]
  })
}

resource "aws_iam_role_policy" "app_pods_messaging_and_data" {
  name = "garageflow-sqs-dynamodb-access"
  role = aws_iam_role.app_pods.name

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

# Os Deployments usam a service account default do namespace.
resource "aws_eks_pod_identity_association" "app_default" {
  cluster_name    = module.eks.cluster_name
  namespace       = local.app_namespace
  service_account = "default"
  role_arn        = aws_iam_role.app_pods.arn
}
