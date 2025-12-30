# Secure AWS API — STRIDE Threat Model

## Architecture
- Lambda Function: Node.js, accesses DynamoDB and KMS
- DynamoDB: KMS-encrypted
- KMS: Customer-managed key, rotation enabled
- IAM: Least-privilege Lambda role
- API Gateway: Exposes REST API
- Cognito: JWT authorizer for authentication
- CloudWatch: Logs all requests

## STRIDE Analysis
- **S — Spoofing**: Cognito JWT prevents unauthorized identity
- **T — Tampering**: KMS encryption protects data integrity; IAM limits access
- **R — Repudiation**: CloudWatch provides audit trail
- **I — Information Disclosure**: Encrypted data + authenticated API access
- **D — Denial of Service**: API Gateway throttling; serverless scaling
- **E — Elevation of Privilege**: IAM role scoped to least privilege


