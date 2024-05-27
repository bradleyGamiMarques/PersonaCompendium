// AWS API Gateway
resource "aws_api_gateway_rest_api" "persona_compendium" {
  name        = "persona_compendium_${var.stage}"
  description = "API Gateway for Persona Compendium services"
  endpoint_configuration {
    types = ["EDGE"]
  }
  lifecycle {
    create_before_destroy = true
  }
}
