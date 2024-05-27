output "v1_get_p3r_personas_by_arcana_http_method" {
  value = aws_api_gateway_method.v1_get_p3r_personas_by_arcana.http_method
}

output "v1_get_p3r_persona_by_name_http_method" {
  value = aws_api_gateway_method.v1_get_p3r_persona_by_name.http_method
}

output "v1_get_p3r_personas_by_arcana" {
  value = aws_api_gateway_method.v1_get_p3r_personas_by_arcana
}

output "v1_get_p3r_persona_by_name" {
  value = aws_api_gateway_method.v1_get_p3r_persona_by_name
}
