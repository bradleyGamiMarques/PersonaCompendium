// API Gateway Resources
resource "aws_api_gateway_resource" "v1" {
  rest_api_id = var.rest_api_id
  parent_id   = var.root_resource_id
  path_part   = "v1"
}

resource "aws_api_gateway_resource" "p3r" {
  rest_api_id = var.rest_api_id
  parent_id   = aws_api_gateway_resource.v1.id
  path_part   = "p3r"
}

resource "aws_api_gateway_resource" "persona" {
  rest_api_id = var.rest_api_id
  parent_id   = aws_api_gateway_resource.p3r.id
  path_part   = "persona"
}

resource "aws_api_gateway_resource" "persona_name" {
  rest_api_id = var.rest_api_id
  parent_id   = aws_api_gateway_resource.persona.id
  path_part   = "{personaName}"
}

resource "aws_api_gateway_resource" "arcana" {
  rest_api_id = var.rest_api_id
  parent_id   = aws_api_gateway_resource.p3r.id
  path_part   = "{arcana}"
}

resource "aws_api_gateway_resource" "personas" {
  rest_api_id = var.rest_api_id
  parent_id   = aws_api_gateway_resource.arcana.id
  path_part   = "personas"
}
