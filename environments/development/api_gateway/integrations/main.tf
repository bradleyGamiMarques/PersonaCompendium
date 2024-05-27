// API Gateway Integrations
resource "aws_api_gateway_integration" "v1_get_p3r_persona_by_name_lambda_integration" {
  rest_api_id             = var.rest_api_id
  resource_id             = var.persona_name_resource_id
  http_method             = var.v1_get_p3r_persona_by_name_http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.v1_get_p3r_persona_by_name_lambda_invoke_arn

  request_parameters = {
    "integration.request.path.personaName" = "method.request.path.personaName"
  }
}
resource "aws_api_gateway_integration" "v1_get_p3r_personas_by_arcana_lambda_integration" {
  rest_api_id             = var.rest_api_id
  resource_id             = var.personas_resource_id
  http_method             = var.v1_get_p3r_personas_by_arcana_http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.v1_get_p3r_personas_by_arcana_lambda_invoke_arn

  request_parameters = {
    "integration.request.path.personaName" = "method.request.path.arcana"
  }
}

resource "aws_lambda_permission" "v1_get_p3r_persona_by_name_apigw_invoke" {
  statement_id  = "AllowAPIGatewayInvoke-get_p3r_persona_by_name"
  action        = "lambda:InvokeFunction"
  function_name = var.v1_get_p3r_persona_by_name_lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.aws_region}:${var.aws_account_id}:${var.rest_api_id}/*/${var.v1_get_p3r_persona_by_name_http_method}${var.persona_name_path}"
}
resource "aws_lambda_permission" "v1_get_p3r_personas_by_arcana_apigw_invoke" {
  statement_id  = "AllowAPIGatewayInvoke-get_p3r_personas_by_arcana"
  action        = "lambda:InvokeFunction"
  function_name = var.v1_get_p3r_personas_by_arcana_lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.aws_region}:${var.aws_account_id}:${var.rest_api_id}/*/${var.v1_get_p3r_personas_by_arcana_http_method}${var.personas_path}"
}
