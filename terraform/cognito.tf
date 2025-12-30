resource "aws_cognito_user_pool" "users" {
  name = "${var.project_name}-users"

  # Optional security settings
  password_policy {
    minimum_length    = 8
    require_uppercase = true
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
  }

  auto_verified_attributes = ["email"]
}

resource "aws_cognito_user_pool_client" "users_client" {
  name         = "secure-api-client"
  user_pool_id = aws_cognito_user_pool.users.id

  generate_secret = false

  # OAuth / OIDC
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows = ["code"]
  allowed_oauth_scopes = [
    "openid",
    "email",
    "profile"
  ]

  supported_identity_providers = ["COGNITO"]

  callback_urls = [
    "https://example.com/callback"
  ]

  logout_urls = [
    "https://example.com/logout"
  ]

  # 🔑 REQUIRED for CLI auth
  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_SRP_AUTH"
  ]
}