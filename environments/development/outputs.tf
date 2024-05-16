output "lambda_execution_role_arn" {
  description = "ARN of lambda execution role"
  value       = aws_iam_role.lambda_execution_role.arn
}
