output "persona_name_resource_id" {
  description = "resource id of persona name resource"
  value       = aws_api_gateway_resource.persona_name.id
}

output "personas_resource_id" {
  description = "resource id of personas resource"
  value       = aws_api_gateway_resource.personas.id
}

output "resource_v1" {
  description = "v1 resource"
  value       = aws_api_gateway_resource.v1
}

output "resource_p3r" {
  description = "p3r resource"
  value       = aws_api_gateway_resource.p3r
}

output "resource_persona" {
  description = "persona resource"
  value       = aws_api_gateway_resource.persona
}

output "resource_persona_name" {
  description = "persona_name resource"
  value       = aws_api_gateway_resource.persona_name
}

output "resource_arcana" {
  description = "arcana resource"
  value       = aws_api_gateway_resource.arcana
}

output "persona_name_path" {
  description = "path of aws_api_gateway_resource personas"
  value       = aws_api_gateway_resource.persona_name.path
}

output "personas_path" {
  description = "path of aws_api_gateway_resource personas"
  value       = aws_api_gateway_resource.personas.path
}

