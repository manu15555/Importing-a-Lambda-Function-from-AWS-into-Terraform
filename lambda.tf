import {
  to = aws_lambda_function.this
  id = "manually-created-lambda"
}

data "archive_file" "lambda_code" {
  type        = "zip"
  source_file = "${path.root}/build/index.mjs"
  output_path = "${path.root}/lambda.zip"
}

resource "aws_lambda_function" "this" {
  description      = "A basic AWS Lambda Function"
  filename         = "lambda.zip"
  function_name    = "manually-created-lambda"
  handler          = "index.handler"
  role             = aws_iam_role.lambda_execution_role.arn
  runtime          = "nodejs22.x"
  source_code_hash = data.archive_file.lambda_code.output_base64sha256
  logging_config {
    log_format = "Text"
    log_group  = "/aws/lambda/manually-created-lambda"
  }
}
