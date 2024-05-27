// API Gateway Methods
resource "aws_api_gateway_method" "v1_get_p3r_persona_by_name" {
  rest_api_id   = var.rest_api_id
  resource_id   = var.persona_name_resource_id
  http_method   = "GET"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.personaName" = true
  }
}
resource "aws_api_gateway_method" "v1_get_p3r_personas_by_arcana" {
  rest_api_id   = var.rest_api_id
  resource_id   = var.personas_resource_id
  http_method   = "GET"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.arcana" = true
  }
}
