import {
  to = aws_iam_role.lambda_execution_role
  id = "manually-created-lambda-role-9xcyze7z"
}

import {
  to = aws_iam_policy.lambda_execution_role
  id = "arn:aws:iam::248563009905:policy/service-role/AWSLambdaBasicExecutionRole-0f5b07c1-8758-490a-a8c7-b2a17516d2b4"
}

data "aws_iam_policy_document" "assume_lambda_execution_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]

  }
}

data "aws_caller_identity" "current" {

}

data "aws_region" "current" {

}

data "aws_iam_policy_document" "assume_lambda_execution" {
  statement {
    effect    = "Allow"
    resources = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"]
    actions   = ["logs:CreateLogGroup"]

  }
  statement {
    effect    = "Allow"
    resources = ["${aws_cloudwatch_log_group.lambda.arn}:*"]
    actions   = ["logs:CreateLogStream", "logs:PutLogEvents"]

  }
}

resource "aws_iam_policy" "lambda_execution_role" {
  description = null
  name        = "AWSLambdaBasicExecutionRole-0f5b07c1-8758-490a-a8c7-b2a17516d2b4"
  path        = "/service-role/"
  policy      = data.aws_iam_policy_document.assume_lambda_execution.json
}

resource "aws_iam_role" "lambda_execution_role" {
  assume_role_policy = data.aws_iam_policy_document.assume_lambda_execution_role.json
  path               = "/service-role/"
}

resource "aws_iam_role_policy_attachment" "lambda_execution" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.lambda_execution_role.arn
}
