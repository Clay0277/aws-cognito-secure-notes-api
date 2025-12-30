# Secure Serverless Notes API

A secure, production-style serverless API built on AWS using Cognito authentication.

## Architecture

- Amazon Cognito User Pool (JWT authentication)
- API Gateway with Cognito Authorizer
- AWS Lambda (Node.js)
- Infrastructure as Code using Terraform

## Features

- Secure `/notes` endpoint protected by JWT access tokens
- Cognito User Pool authentication (USER_PASSWORD_AUTH)
- API Gateway authorizer enforcement
- Clean separation of infrastructure and application logic

## Authentication Flow

1. User authenticates via Cognito
2. Cognito issues JWT Access Token
3. Client sends token as `Authorization: Bearer <token>`
4. API Gateway validates token before invoking Lambda

## Tech Stack

- AWS API Gateway
- AWS Lambda (Node.js)
- Amazon Cognito
- Terraform

## Status

Backend authentication and authorization fully working.
Frontend integration in progress.
