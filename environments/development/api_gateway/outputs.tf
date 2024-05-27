output "rest_api_id" {
  value = aws_api_gateway_rest_api.persona_compendium.id
}

output "root_resource_id" {
  description = "Root resource id of api gateway"
  value       = aws_api_gateway_rest_api.persona_compendium.root_resource_id
}

output "api_gateway_execution_arn" {
  description = "Execution arn"
  value       = aws_api_gateway_rest_api.persona_compendium.execution_arn
}
