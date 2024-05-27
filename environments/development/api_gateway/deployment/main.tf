resource "aws_api_gateway_stage" "persona_compendium" {
  deployment_id = aws_api_gateway_deployment.dev_deployment.id
  rest_api_id   = var.rest_api_id
  stage_name    = var.stage
}

// API Gateway dev deployment
resource "aws_api_gateway_deployment" "dev_deployment" {
  depends_on = [
    var.v1_get_p3r_persona_by_name_lambda_integration,
    var.v1_get_p3r_personas_by_arcana_lambda_integration,
    var.v1_get_p3r_persona_by_name_method,
    var.v1_get_p3r_personas_by_arcana_method,
    var.resource_v1,
    var.resource_p3r,
    var.resource_persona,
    var.resource_persona_name,
    var.resource_arcana
  ]
  rest_api_id = var.rest_api_id
  triggers = {
    redeployment = var.combined_hash
  }
  lifecycle {
    create_before_destroy = true
  }
}
