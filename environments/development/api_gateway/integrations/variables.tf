variable "rest_api_id" {
  description = "Rest api id of api gateway"
  type        = string
}
variable "persona_name_resource_id" {
  description = "resource id of persona api_gateway resource"
  type        = string
}
variable "personas_resource_id" {
  description = "resource id of personas api_gateway resource"
  type        = string
}

variable "persona_name_path" {
  description = "path of aws_api_gateway_resource persona_name"
  type        = string
}

variable "personas_path" {
  description = "path of aws_api_gateway_resource personas"
  type        = string
}

variable "aws_account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-1"
}

variable "v1_get_p3r_persona_by_name_http_method" {
  description = "http method of api_gateway_method v1_get_p3r_persona_by_name"
}

variable "v1_get_p3r_personas_by_arcana_http_method" {
  description = "http method of api_gateway_method v1_get_p3r_personas_by_arcana"
}

variable "v1_get_p3r_persona_by_name_lambda_function_name" {
  description = "function name of aws_lambda_function v1_get_p3r_persona_by_name"
}

variable "v1_get_p3r_persona_by_name_lambda_invoke_arn" {
  description = "invoke_arn of aws_lambda_function v1_get_p3r_persona_by_name"
}

variable "v1_get_p3r_personas_by_arcana_lambda_function_name" {
  description = "function name of aws_lambda_function v1_get_p3r_personas_by_arcana"
}

variable "v1_get_p3r_personas_by_arcana_lambda_invoke_arn" {
  description = "invoke_arn of aws_lambda_function v1_get_p3r_personas_by_arcana"
}
