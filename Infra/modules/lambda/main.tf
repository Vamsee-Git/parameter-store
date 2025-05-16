variable "kms_key_arn" {}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_ssm_access_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy" "lambda_policy" {
  name = "lambda_ssm_access_policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ssm:GetParameter",
          "kms:Decrypt"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

resource "aws_lambda_function" "read_ssm" {
  filename         = "lambda_function_payload.zip"
  function_name    = "ReadSSMParameter"
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_function_payload.lambda_handler"
  runtime          = "python3.10"
  source_code_hash = filebase64sha256("lambda_function_payload.zip")
}
