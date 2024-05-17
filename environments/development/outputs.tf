output "lambda_execution_role_arn" {
  description = "ARN of lambda execution role"
  value       = aws_iam_role.lambda_execution_role.arn
}

output "lambda_execution_role_id" {
  description = "ID of lambda execution role"
  value       = aws_iam_role.lambda_execution_role.id
}

output "p3r_personas_table_name" {
  description = "Name of the DynamoDB table where Persona 3 Reload Persona data is stored"
  value       = module.persona_3_reload_personas_table.table_name
}

output "aws_account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "aws_region" {
  description = "Region where resources are located"
  value       = var.aws_region
}

output "persona_compendium_terraform_state_bucket" {
  description = "Name of the S3 bucket that holds our .tfstate file"
  value       = var.persona_compendium_terraform_state_bucket
}

output "key" {
  description = "Path to .tfstate file in S3"
  value       = var.key
}
