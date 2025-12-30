resource "aws_lambda_function" "notes" {
  function_name = "${var.project_name}-handler"
  role          = aws_iam_role.lambda_role.arn
  runtime       = "nodejs18.x"
  handler       = "index.handler"

  filename = "${path.module}/../lambda/function.zip"

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.notes.name
      KMS_KEY    = aws_kms_key.notes_key.arn
    }
  }
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.notes.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.notes_api.execution_arn}/*/*"
}