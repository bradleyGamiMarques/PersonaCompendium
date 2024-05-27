variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table where Persona 3 Reload Persona data is stored"
}

variable "lambda_execution_role_arn" {
  description = "ARN of lambda execution role"
}

variable "get_p3r_persona_by_name_log_group_name" {
  description = "name of the get_p3r_persona_by_name_log_group"
}

variable "get_p3r_personas_by_arcana_log_group_name" {
  description = "name of the get_p3r_personas_by_arcana_log_group"
}
