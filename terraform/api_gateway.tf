# API Gateway REST API
resource "aws_api_gateway_rest_api" "notes_api" {
  name        = "${var.project_name}-api"
  description = "Secure Notes API"
}

# Root Resource
resource "aws_api_gateway_resource" "notes_resource" {
  rest_api_id = aws_api_gateway_rest_api.notes_api.id
  parent_id   = aws_api_gateway_rest_api.notes_api.root_resource_id
  path_part   = "notes"
}

# Cognito Authorizer
resource "aws_api_gateway_authorizer" "cognito_auth" {
  name                   = "cognito-auth"
  rest_api_id            = aws_api_gateway_rest_api.notes_api.id
  identity_source        = "method.request.header.Authorization"
  type                   = "COGNITO_USER_POOLS"
  provider_arns          = [aws_cognito_user_pool.users.arn]
}

# GET /notes method
resource "aws_api_gateway_method" "get_notes" {
  rest_api_id   = aws_api_gateway_rest_api.notes_api.id
  resource_id   = aws_api_gateway_resource.notes_resource.id
  http_method   = "GET"

  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_auth.id

  authorization_scopes = [
    "aws.cognito.signin.user.admin"
  ]
}

# Integration with Lambda
resource "aws_api_gateway_integration" "get_notes_integration" {
  rest_api_id = aws_api_gateway_rest_api.notes_api.id
  resource_id = aws_api_gateway_resource.notes_resource.id
  http_method = aws_api_gateway_method.get_notes.http_method
  type        = "AWS_PROXY"
  integration_http_method = "POST"
  uri         = aws_lambda_function.notes.invoke_arn
}

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.notes_api.id

  # Forces redeployment whenever the API definition changes
  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.notes_api))
  }

  depends_on = [
    aws_api_gateway_integration.get_notes_integration
  ]
}

# Create a stage explicitly instead of using stage_name
resource "aws_api_gateway_stage" "prod" {
  stage_name    = "prod"
  rest_api_id   = aws_api_gateway_rest_api.notes_api.id
  deployment_id = aws_api_gateway_deployment.deployment.id
}